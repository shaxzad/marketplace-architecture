-- Supabase/Postgres schema for bib-marketplace marketplace
create extension if not exists "pgcrypto";

create type event_status as enum ('scheduled', 'completed', 'cancelled');
create type listing_status as enum ('draft', 'active', 'sold', 'expired', 'flagged');
create type listing_moderation_status as enum ('pending_review', 'approved', 'rejected', 'blocked');
create type contact_request_status as enum ('pending', 'accepted', 'rejected', 'cancelled');

create table users (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  display_name text,
  public_bio text,
  contact_email text,
  contact_phone text,
  created_at timestamptz not null default now()
);

create table events (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  location text,
  starts_at timestamptz,
  ends_at timestamptz,
  requires_approval boolean not null default false,
  status event_status not null default 'scheduled',
  created_at timestamptz not null default now()
);

create table listings (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references events(id) on delete cascade,
  seller_id uuid not null references users(id) on delete cascade,
  title text not null,
  description text,
  price numeric(12,2) not null check (price >= 0),
  status listing_status not null default 'draft',
  moderation_status listing_moderation_status not null default 'pending_review',
  expires_at timestamptz,
  flagged_reason text,
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index on listings(status);
create index on listings(moderation_status);
create index on listings(event_id);
create index on listings(seller_id);

create table contact_requests (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references listings(id) on delete cascade,
  buyer_id uuid not null references users(id) on delete cascade,
  message text,
  status contact_request_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index contact_requests_unique_listing_buyer on contact_requests(listing_id, buyer_id);

create table alerts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  event_id uuid references events(id) on delete set null,
  criteria jsonb not null default '{}'::jsonb,
  enabled boolean not null default true,
  created_at timestamptz not null default now()
);

create index on alerts(user_id);
create index on alerts(event_id);

-- Row Level Security policies

alter table users enable row level security;
alter table events enable row level security;
alter table listings enable row level security;
alter table contact_requests enable row level security;
alter table alerts enable row level security;

create or replace function public.is_admin() returns boolean stable language sql as $$
  select current_setting('jwt.claims.role', true) = 'admin';
$$;

create or replace function public.can_view_seller_contact(requesting_user uuid, seller_id uuid) returns boolean stable language sql as $$
  select exists (
    select 1
    from contact_requests cr
    join listings l on cr.listing_id = l.id
    where cr.buyer_id = requesting_user
      and l.seller_id = seller_id
      and cr.status = 'accepted'
  );
$$;

create view public_user_profiles as
select id, name, display_name, public_bio, created_at
from users;

create view public_listings as
select id, event_id, seller_id, title, description, price, expires_at, created_at, updated_at
from listings
where status = 'active'
  and moderation_status = 'approved'
  and is_public;

create policy "users_select_self_or_accepted_contact" on users
for select using (
  auth.uid()::uuid = id
  or public.can_view_seller_contact(auth.uid()::uuid, id)
  or public.is_admin()
);

create policy "users_update_own_profile" on users
for update using (auth.uid()::uuid = id);

create policy "events_select_public" on events
for select using (true);

create policy "events_insert_authenticated" on events
for insert with check (auth.uid() is not null);

create policy "events_update_admin" on events
for update using (public.is_admin());

create policy "events_delete_admin" on events
for delete using (public.is_admin());

create policy "listings_select_visible" on listings
for select using (
  auth.uid()::uuid = seller_id
  or public.is_admin()
  or (
    status = 'active'
    and moderation_status = 'approved'
    and is_public
  )
);

create policy "listings_insert_owner" on listings
for insert with check (auth.uid()::uuid = seller_id);

create policy "listings_update_owner_or_admin" on listings
for update using (
  auth.uid()::uuid = seller_id
  or public.is_admin()
);

create policy "listings_delete_owner_or_admin" on listings
for delete using (
  auth.uid()::uuid = seller_id
  or public.is_admin()
);

create policy "contact_requests_select_buyer_or_seller" on contact_requests
for select using (
  auth.uid()::uuid = buyer_id
  or auth.uid()::uuid = (
    select seller_id from listings where id = contact_requests.listing_id
  )
  or public.is_admin()
);

create policy "contact_requests_insert_buyer" on contact_requests
for insert with check (
  auth.uid()::uuid = buyer_id
  and exists (
    select 1 from listings l
    where l.id = contact_requests.listing_id
      and l.status = 'active'
      and l.moderation_status = 'approved'
  )
);

create policy "contact_requests_update_buyer_or_seller" on contact_requests
for update using (
  auth.uid()::uuid = buyer_id
  or auth.uid()::uuid = (
    select seller_id from listings where id = contact_requests.listing_id
  )
  or public.is_admin()
);

create policy "alerts_select_owner" on alerts
for select using (auth.uid()::uuid = user_id);

create policy "alerts_insert_owner" on alerts
for insert with check (auth.uid()::uuid = user_id);

create policy "alerts_update_owner" on alerts
for update using (auth.uid()::uuid = user_id);

create policy "alerts_delete_owner" on alerts
for delete using (auth.uid()::uuid = user_id);
