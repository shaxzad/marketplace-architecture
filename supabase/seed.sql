-- Seed data for bib-marketplace marketplace

insert into users (id, name, display_name, public_bio, contact_email, contact_phone)
values
  ('11111111-1111-1111-1111-111111111111', 'Alice Seller', 'Alice', 'Vintage event seller focused on trusted exchanges.', 'alice@example.com', '+1-555-0101'),
  ('22222222-2222-2222-2222-222222222222', 'Bob Buyer', 'Bob', 'Buyer looking for safe event resale tickets.', 'bob@example.com', '+1-555-0202'),
  ('33333333-3333-3333-3333-333333333333', 'Carol Vendor', 'Carol', 'Professional reseller with great ratings.', 'carol@example.com', '+1-555-0303'),
  ('44444444-4444-4444-4444-444444444444', 'David Collector', 'David', 'Enthusiast collector of rare items.', 'david@example.com', '+1-555-0404'),
  ('55555555-5555-5555-5555-555555555555', 'Emma Events', 'Emma', 'Event coordinator and marketplace admin.', 'emma@example.com', '+1-555-0505');

insert into events (id, name, description, location, starts_at, ends_at, requires_approval, status)
values
  ('00000000-0000-0000-0000-000000000001', 'Spring College Festival', 'Campus marketplace event for ticket and goods resale.', 'University Green', '2026-05-20 10:00:00+00', '2026-05-20 18:00:00+00', true, 'scheduled'),
  ('00000000-0000-0000-0000-000000000002', 'Senior Party Marketday', 'Student alumni party resale market.', 'Downtown Hall', '2026-06-10 18:00:00+00', '2026-06-10 22:00:00+00', false, 'scheduled'),
  ('00000000-0000-0000-0000-000000000003', 'Book Swap & Trade Fair', 'Annual textbook and novel exchange event.', 'Library Courtyard', '2026-04-15 12:00:00+00', '2026-04-15 20:00:00+00', false, 'scheduled'),
  ('00000000-0000-0000-0000-000000000004', 'Tech Summit Resale', 'Sell your gadgets and conference gear.', 'Convention Center', '2026-07-05 09:00:00+00', '2026-07-05 21:00:00+00', true, 'scheduled'),
  ('00000000-0000-0000-0000-000000000005', 'Art & Craft Market', 'Handmade goods and student artwork marketplace.', 'Arts Building Plaza', '2026-05-01 11:00:00+00', '2026-05-01 19:00:00+00', false, 'scheduled'),
  ('00000000-0000-0000-0000-000000000006', 'Sports Equipment Swap', 'Sell and buy used sports gear.', 'Athletic Center', '2026-06-22 14:00:00+00', '2026-06-22 20:00:00+00', false, 'scheduled'),
  ('00000000-0000-0000-0000-000000000007', 'Music Instruments Fair', 'Buy, sell, and trade musical instruments.', 'Music Hall Auditorium', '2026-08-10 16:00:00+00', '2026-08-10 22:00:00+00', true, 'scheduled'),
  ('00000000-0000-0000-0000-000000000008', 'Vintage & Collectibles Auction', 'Premium resale event for rare items.', 'Grand Hotel Ballroom', '2026-09-15 10:00:00+00', '2026-09-15 18:00:00+00', true, 'scheduled');

insert into listings (id, event_id, seller_id, title, description, price, status, moderation_status, is_public, expires_at)
values
  -- Alice's listings
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Campus Debate Ticket', 'One ticket to the student debate event. Unused, transferable.', 20.00, 'active', 'approved', true, '2026-05-19 23:59:59+00'),
  ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'VIP Dance Pass', 'Early access pass for the senior meetup.', 45.00, 'draft', 'pending_review', false, '2026-06-09 23:59:59+00'),
  ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 'Organic Chemistry Textbook', 'Used textbook, excellent condition. All notes included.', 35.00, 'active', 'approved', true, '2026-04-20 23:59:59+00'),
  -- Carol's listings
  ('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000004', '33333333-3333-3333-3333-333333333333', 'Wireless Earbuds Pro', 'Brand new, sealed, original packaging. High-end audio.', 120.00, 'active', 'approved', true, '2026-07-01 23:59:59+00'),
  ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000005', '33333333-3333-3333-3333-333333333333', 'Handmade Ceramic Vase', 'Beautiful blue glaze, one of a kind, slightly chipped.', 25.00, 'active', 'approved', true, '2026-05-05 23:59:59+00'),
  ('10000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000006', '33333333-3333-3333-3333-333333333333', 'Mountain Bike', 'Adult hybrid bike, well maintained, ready to ride.', 200.00, 'sold', 'approved', true, '2026-06-20 23:59:59+00'),
  -- David's listings
  ('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000007', '44444444-4444-4444-4444-444444444444', 'Vintage Acoustic Guitar', 'Fender acoustic, 1995, good playability, minor cosmetic wear.', 250.00, 'active', 'approved', true, '2026-08-05 23:59:59+00'),
  ('10000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000008', '44444444-4444-4444-4444-444444444444', 'Rare Comic Book - First Edition', 'Spider-Man #1 reprint, mint condition in protective case.', 150.00, 'active', 'approved', true, '2026-09-10 23:59:59+00'),
  -- Additional listings (draft/expired for testing)
  ('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'Concert Ticket - Expired', 'This listing has expired.', 55.00, 'expired', 'approved', true, '2026-02-01 23:59:59+00'),
  ('10000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000004', '33333333-3333-3333-3333-333333333333', 'Laptop Stand - Flagged', 'This listing was flagged for policy violation.', 30.00, 'flagged', 'rejected', false, '2026-07-01 23:59:59+00');

insert into contact_requests (id, listing_id, buyer_id, message, status)
values
  ('20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'Hi, is this ticket still available? Interested in buying.', 'pending'),
  ('20000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000004', '22222222-2222-2222-2222-222222222222', 'Are these still in stock? Looking to purchase immediately.', 'accepted'),
  ('20000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000007', '55555555-5555-5555-5555-555555555555', 'Perfect item! Ready to commit. What payment methods work?', 'pending');

insert into alerts (id, user_id, event_id, criteria, enabled)
values
  ('30000000-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', '00000000-0000-0000-0000-000000000001', '{"price_max": 50, "keywords": ["ticket", "pass"]}'::jsonb, true),
  ('30000000-0000-0000-0000-000000000002', '44444444-4444-4444-4444-444444444444', '00000000-0000-0000-0000-000000000007', '{"price_min": 50, "categories": ["instruments"]}'::jsonb, true);
