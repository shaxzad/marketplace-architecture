# bib-marketplace-architecture

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
- Transfer model note: `docs/TRANSFER_RULES.md`
- Demand snapshot and alerts recommendation: `docs/DEMAND_SNAPSHOT_AND_ALERTS.md`
- Use `.env.example` for environment variable templates

**Q: RLS policies seem broken. How do I debug?**
A: Use Supabase Studio → DB Inspector → RLS Policies. Test with different user roles.

**Q: What's the difference between `SUPABASE_ANON_KEY` and `SERVICE_ROLE_KEY`?**
A: 
- **ANON_KEY**: Public, used by frontend. Respects RLS.
- **SERVICE_ROLE_KEY**: Secret, used by backend. Bypasses RLS. **Never expose client-side.**

## Next Steps

1. ✅ **Schema & migrations**: Done and tested locally
2. ✅ **Seed data**: 8 events, 5 users, 10 listings
3. ✅ **RLS policies**: Enabled and documented
4. 🔙 **Backend integration**: Connect to Supabase via SDK
5. 🔙 **Frontend**: Build listing browser, user authentication
6. 🔙 **Testing**: Write integration tests for RLS

## Support & Documentation

- [Supabase Docs](https://supabase.com/docs)
- [PostgreSQL RLS Guide](https://www.postgresql.org/docs/current/sql-createrole.html)
- [Project Architecture](docs/architecture.md)
- [Environment Setup](docs/ENV_SETUP.md)

---

**Ready to go!** Clone, run these 3 commands, and you're live:
```bash
supabase start && supabase db reset && supabase status
```
