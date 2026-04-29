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
- A `public_listings` view is defined to expose only active, approved, and public listings when read access is granted.
- A `public_user_profiles` view is defined for public profile fields when read access is granted.
- Seller contact details remain hidden unless a buyer has an accepted contact request.
- SQL privilege revokes are used to reduce GraphQL schema discoverability for `anon` and `authenticated` roles.

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
- Listing row visibility is controlled by RLS policy conditions (`active`, `approved`, `is_public`) plus seller/admin access.
- Seller may always see their own listings regardless of status.
- Admin users can bypass restrictions.

### Who can see seller contact details
- Seller contact details are stored in `users.contact_email` and `users.contact_phone`.
- Only the seller and a buyer with an accepted `contact_requests` row can access that private information.
- When public browsing is enabled, use `public_listings` to avoid leaking sensitive contact info.

### Buyer ↔ seller interaction
- Buyers create a `contact_requests` row for a specific listing.
- Sellers can accept or reject the request.
- Only after acceptance can the buyer access seller contact details.
- This keeps initial browsing and searching safe while still enabling direct contact.
- In MVP, `contact_requests` is the transfer-rule model (request, accept/reject, contact unlock); event approval constraints are represented by `events.requires_approval` and enforced in app workflow.

## 4) Demand snapshot / alerts recommendation (MVP-safe)

- Keep `alerts` as lightweight watcher subscriptions with JSON criteria (`price`, `keywords`, optional `event_id` scope).
- For MVP, prioritize event/listing matching logic first and avoid over-normalizing alert criteria.
- For post-MVP analytics, add an additive `demand_snapshots` table (or materialized view) with periodic aggregates:
  - event/listing demand counts
  - accepted contact-request counts
  - price trend metrics (min/median/max)
- Suggested cadence: hourly baseline, tighter interval near event dates.
- This keeps MVP simple while leaving a clean path for trend indicators and alert ranking.

## 5) Key design decisions

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
- Strict `SELECT` revokes reduce GraphQL discoverability but may require explicit grants later for public browsing use cases.

## Milestone 1 deliverables in repo
- `supabase/schemas/0001_schema.sql`
- `supabase/schemas/0002_policies.sql`
- `supabase/seed.sql`
- `docs/architecture.md`
- `docs/ERD.md`
- `docs/VALIDATION.md`
