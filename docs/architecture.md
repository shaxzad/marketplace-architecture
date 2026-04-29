# Architecture and delivery notes for bib-marketplace-architecture

## 1) Schema design

### Core tables
- `users`
  - User profile table for buyers and sellers.
  - Contains public profile fields plus private contact fields.
- `events`
  - Marketplace event container.
  - Supports approval requirements and scheduled dates.
- `listings`
  - Core marketplace item table.
  - Each listing belongs to an event and a seller.
  - Includes lifecycle state, moderation state, expiration, and visibility flags.
- `contact_requests`
  - Buyer-seller interaction mediator.
  - Buyers request contact through a listing instead of exposing seller contact publicly.
- `alerts`
  - Optional watcher/alert table for event or listing notifications.
  - Keeps criteria in JSON for flexible subscription rules.

### Key design notes
- A `public_listings` view is provided for safe browse access to only active, approved, and public listings.
- A `public_user_profiles` view exposes only public user fields.
- Seller contact details remain hidden unless a buyer has an accepted contact request.

## 2) Listing lifecycle

### Status flow
- `draft` -> `active` -> `sold`
- `draft` -> `expired`
- `draft` -> `flagged`
- `active` -> `sold`
- `active` -> `expired`
- `active` -> `flagged`

### Moderation states
- `pending_review`
- `approved`
- `rejected`
- `blocked`

### Why this split?
- `status` tracks marketplace lifecycle.
- `moderation_status` tracks admin/moderation review separately.
- This lets `active` listings be held back by moderation until approved.

## 3) RLS / access model

### Who can see listings
- `active`, `approved`, and `is_public = true` listings are visible to everyone.
- Seller may always see their own listings regardless of status.
- Admin users can bypass restrictions.

### Who can see seller contact details
- Seller contact details are stored in `users.contact_email` and `users.contact_phone`.
- Only the seller and a buyer with an accepted `contact_requests` row can access that private information.
- General listing browsing uses `public_listings` to avoid leaking sensitive contact info.

### Buyer ↔ seller interaction
- Buyers create a `contact_requests` row for a specific listing.
- Sellers can accept or reject the request.
- Only after acceptance can the buyer access seller contact details.
- This keeps initial browsing and searching safe while still enabling direct contact.

## 4) Key design decisions

### Excluded from MVP
- Full messaging/chat system.
- Payments or escrow.
- Multi-seller approvals and complex buyer verification.
- Separate `messages` or `conversations` tables.
- Full audit logging and advanced reporting.

### Tradeoffs and risks
- Using `users` as the profile table plus direct contact columns is simple, but contact privacy depends on correct RLS policy implementation.
- The `alerts` table stores criteria as JSON, which is flexible but may need normalization later for query performance.
- `status` and `moderation_status` are intentionally separated, which adds clarity but also requires careful frontend state handling.
- Admin workflows are currently assumed to be handled via a role claim (`admin`) or service role.

## Milestone 1 deliverables in repo
- `supabase/schemas/0001_schema.sql`
- `supabase/schemas/0002_policies.sql`
- `supabase/seed.sql`
- `docs/architecture.md`
- `docs/ERD.md`

## Next transfer step
1. Push this repo into the client-owned Supabase project.
2. Run `supabase db reset` in the client environment to load schema and seed data.
3. Confirm RLS policies by testing as buyer, seller, and anonymous user.
4. Use the `public_listings` and `public_user_profiles` views in the frontend to avoid accidental sensitive exposure.
