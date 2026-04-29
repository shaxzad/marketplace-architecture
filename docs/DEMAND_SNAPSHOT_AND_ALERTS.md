# Demand Snapshot and Alerts Recommendation

This document provides the Milestone 1 recommendation note for demand snapshots and alert structure.

## Existing MVP structure

- `alerts` table already stores per-user criteria as JSON (`criteria jsonb`).
- Alerts can be event-scoped via `event_id` and toggled with `enabled`.
- RLS scopes alerts to their owner.

## Recommended demand snapshot model

Use a lightweight periodic snapshot table for analytics and ranking:

- Table: `demand_snapshots`
  - `id` uuid primary key
  - `event_id` uuid not null
  - `listing_id` uuid null (null when event-level aggregate)
  - `snapshot_at` timestamptz not null
  - `active_listing_count` int not null default 0
  - `contact_request_count` int not null default 0
  - `accepted_request_count` int not null default 0
  - `median_price` numeric(12,2) null
  - `min_price` numeric(12,2) null
  - `max_price` numeric(12,2) null

Indexes:

- `(event_id, snapshot_at desc)`
- `(listing_id, snapshot_at desc)` where `listing_id is not null`

## Snapshot cadence

- MVP: hourly snapshot job (Supabase scheduled function or external cron).
- For high-activity periods (near event date), increase to every 15 minutes.

## How snapshots connect to alerts

1. New listing / listing update events are matched against `alerts.criteria`.
2. Demand snapshots provide trend context ("spiking demand", "price shift").
3. Alert payload should include:
   - matched listing summary
   - current price
   - recent demand delta (for event or listing cohort)

## Criteria shape recommendation

Keep JSON criteria simple and stable:

```json
{
  "price_min": 20,
  "price_max": 80,
  "keywords": ["ticket", "vip"],
  "categories": ["concert"],
  "listing_status": ["active"],
  "moderation_status": ["approved"]
}
```

## Why this is MVP-safe

- No immediate schema rewrite needed for current `alerts`.
- Snapshot model is additive and can be introduced in a later migration.
- Supports future recommendation/notification ranking with minimal coupling.
