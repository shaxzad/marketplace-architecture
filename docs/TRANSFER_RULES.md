# Transfer Rules (MVP)

This note formalizes the transfer model represented in Milestone 1.

## Current MVP model in schema

- Transfer intent is represented by `contact_requests`.
- A buyer starts transfer negotiation by creating a request tied to a listing.
- A seller can accept or reject the request.
- Contact unlock rule: seller private contact fields are accessible only after an accepted request.

## Rule set (enforced now)

1. Buyer can only create request rows for themselves (`auth.uid() = buyer_id`).
2. Request creation is limited to active + approved listings.
3. Buyer and listing seller can read/update relevant request rows.
4. Seller contact details are gated behind accepted request status.

## Event-level transfer policy guidance

Use `events.requires_approval` as the first event-level transfer gate:

- `requires_approval = false`: standard flow (`pending` -> `accepted`/`rejected`).
- `requires_approval = true`: require a moderation/organizer step before seller final acceptance in the app workflow.

For Milestone 1 this is an application/workflow rule, not a separate database table.

## Recommended phase-2 explicit model (optional)

If stricter transfer controls are needed, add:

- `event_transfer_rules` table keyed by `event_id`
  - `allowed_methods` (jsonb or enum array)
  - `transfer_deadline_hours_before_start` (int)
  - `requires_identity_match` (boolean)
  - `max_transfers_per_listing` (int)
  - `notes` (text)

This allows per-event rule variance without overloading listing logic.
