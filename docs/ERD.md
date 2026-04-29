# ERD summary for bib-marketplace-architecture

## Tables

### users
- id (PK)
- name
- display_name
- public_bio
- contact_email
- contact_phone
- created_at

### events
- id (PK)
- name
- description
- location
- starts_at
- ends_at
- requires_approval
- status
- created_at

### listings
- id (PK)
- event_id (FK → events.id)
- seller_id (FK → users.id)
- title
- description
- price
- status
- moderation_status
- expires_at
- flagged_reason
- is_public
- created_at
- updated_at

### contact_requests
- id (PK)
- listing_id (FK → listings.id)
- buyer_id (FK → users.id)
- message
- status
- created_at
- updated_at

### alerts
- id (PK)
- user_id (FK → users.id)
- event_id (FK → events.id)
- criteria
- enabled
- created_at

## Relationships
- listings.seller_id → users.id
- listings.event_id → events.id
- contact_requests.listing_id → listings.id
- contact_requests.buyer_id → users.id
- alerts.user_id → users.id
- alerts.event_id → events.id

## Lifecycle model
- listing status: draft, active, sold, expired, flagged
- moderation state: pending_review, approved, rejected, blocked

## Notes
- `users` acts as the profile table, with private contact fields protected by RLS.
- `contact_requests` is the secure buyer-to-seller interaction layer.
- `alerts` is optional and built for watcher-style notifications.
