# marketplace-architecture

A secure, event-based marketplace schema built with Supabase (PostgreSQL + RLS).

## Quick Start

```bash
supabase start
supabase db reset
supabase status
```

## Local URLs

- API: http://127.0.0.1:54321
- Studio: http://127.0.0.1:54323
- Database: postgresql://postgres:postgres@127.0.0.1:54322/postgres

## Notes

- Schema and migrations are in `supabase/migrations`
- Seed data is in `supabase/seed.sql`
- Refer to `docs/architecture.md` for design and RLS details
- Validation checklist is in `docs/VALIDATION.md`
- Use `.env.example` for environment variable templates

## Next Steps

1. ✅ **Schema & migrations**: Done and tested locally
2. ✅ **Seed data**: 8 events, 5 users, 10 listings
3. ✅ **RLS policies**: Enabled and documented

---

**Ready to go!** Clone, run these 3 commands, and you're live:

```bash
supabase start && supabase db reset && supabase status
```
