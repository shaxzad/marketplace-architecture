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
