# Environment Setup Guide

## Local Development

### 1. Copy the local env file
```bash
# Already created at repo root
ls -la .env.local
```

### 2. Ensure Supabase is running
```bash
supabase status
```

The `.env.local` file contains credentials from the local Supabase instance.

### 3. Load env variables in your app

**Python (FastAPI):**
```python
from dotenv import load_dotenv
import os

load_dotenv('.env.local')

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_ANON_KEY')
DATABASE_URL = os.getenv('DATABASE_URL')
```

**Node.js:**
```javascript
require('dotenv').config({ path: '.env.local' });

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_ANON_KEY;
```

## Production Deployment (Client environment)

### 1. Create a new Supabase project
- Go to https://app.supabase.com
- Create a new project
- Copy the project URL and keys

### 2. Update `.env.production`
```bash
# Use the values from your Supabase project dashboard
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=<from dashboard>
SUPABASE_SERVICE_ROLE_KEY=<from dashboard>
```

### 3. Push schema to production Supabase
```bash
# Link your local repo to the remote Supabase project
supabase link --project-ref your-project-id

# Push migrations
supabase db push

# If you need to reset (⚠️ PRODUCTION DATA LOSS):
supabase db reset --linked
```

### 4. Deploy your app
- Use your deployment platform (Vercel, Railway, etc.)
- Set the `.env.production` variables in the deployment environment

## Environment Variables Reference

| Variable | Purpose | Example |
|----------|---------|---------|
| `SUPABASE_URL` | API endpoint | `http://127.0.0.1:54321` or `https://xyz.supabase.co` |
| `SUPABASE_ANON_KEY` | Public client key | `sb_publishable_...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Admin/backend key | `sb_secret_...` |
| `DATABASE_URL` | Direct DB connection | `postgresql://user:pass@host:5432/db` |
| `API_HOST` | Backend listen address | `0.0.0.0` |
| `API_PORT` | Backend port | `8000` |
| `JWT_SECRET` | JWT signing key | Random secret string |
| `STORAGE_BUCKET` | S3 bucket name | `marketplace-items` |

## Multi-environment workflow

```bash
# Local development
source .env.local
# or in Python app: load_dotenv('.env.local')

# Staging (if needed)
source .env.staging
# Deploy to staging environment

# Production
source .env.production
# Deploy to production
```

## Security notes
- ✅ `.env.local` and `.env` are in `.gitignore` and will not be committed
- ✅ `.env.example` shows the template and can be committed
- ✅ Keep `SUPABASE_SERVICE_ROLE_KEY` secret and backend-only
- ✅ Rotate `JWT_SECRET` in production
- ✅ Use strong, unique passwords for production databases
