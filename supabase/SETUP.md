# SwipeBase + Supabase Setup Guide

## 1. Create Supabase Project

1. Go to https://supabase.com
2. Sign in / Create account
3. Click "New Project"
4. Settings:
   - Name: `swipebase`
   - Database Password: (save this!)
   - Region: Choose closest to you
5. Wait for project to be created (~2 min)

## 2. Run Database Schema

1. In Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy contents of `schema.sql` (from this folder)
4. Click "Run"
5. Should see success messages for all tables

## 3. Enable Auth Providers

### Magic Link (Email)
1. Go to **Authentication** > **Providers**
2. Email should be enabled by default
3. Optional: Customize email templates in **Email Templates**

### Google OAuth
1. Go to **Authentication** > **Providers** > **Google**
2. Enable Google
3. Create OAuth credentials at https://console.cloud.google.com/apis/credentials
   - OAuth consent screen: External
   - Create OAuth Client ID: Web application
   - Authorized redirect URI: `https://YOUR_PROJECT.supabase.co/auth/v1/callback`
4. Copy Client ID and Secret to Supabase

## 4. Get API Credentials

1. Go to **Settings** > **API**
2. Copy:
   - **Project URL** (e.g., `https://abc123.supabase.co`)
   - **anon public** key (starts with `eyJ...`)

## 5. Update SwipeBase

Edit `swipebase-cloud.html` and replace:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

With your actual values:

```javascript
const SUPABASE_URL = 'https://abc123.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

## 6. Configure Site URL

1. Go to **Authentication** > **URL Configuration**
2. Set **Site URL** to your app URL:
   - Local: `http://localhost:3333`
   - Production: `https://rufus.yesno.events`
3. Add **Redirect URLs**:
   - `http://localhost:3333/swipebase-cloud.html`
   - `https://rufus.yesno.events/swipebase-cloud.html`

## 7. Test

1. Start local server: `cd ~/Rufus/projects/rufus-dashboard && npm start`
2. Open http://localhost:3333/swipebase-cloud.html
3. Click "Sign In"
4. Try Magic Link or Google
5. Upload a CSV and click "Save to Cloud"
6. Refresh page - deck should appear in "My Decks"

## Files

```
supabase/
├── schema.sql       # Database schema (run in SQL Editor)
└── SETUP.md         # This file

public/
├── swipebase.html       # Original (client-side only)
└── swipebase-cloud.html # With Supabase integration
```

## Database Structure

### Tables

| Table | Purpose |
|-------|---------|
| `decks` | User's saved decks |
| `cards` | Items in each deck |
| `decisions` | User's swipe decisions |

### Row Level Security

- Users can only see/edit their own decks
- Public decks visible to anyone via share_id
- Decisions are private per user

## Features Added

- **Magic Link auth** - Passwordless email login
- **Google OAuth** - One-click sign in
- **Save to Cloud** - Persist decks and decisions
- **My Decks** - Load previous decks
- **Share Deck** - Generate public link
- **Cross-device sync** - Decisions saved per user

## Troubleshooting

### "Supabase not configured"
- Check SUPABASE_URL and SUPABASE_ANON_KEY are set

### Auth redirect fails
- Check Site URL and Redirect URLs in Supabase
- Ensure URL matches exactly (with/without trailing slash)

### RLS errors
- Make sure schema.sql ran completely
- Check policies in Authentication > Policies

### Google sign-in fails
- Verify OAuth credentials in Google Cloud Console
- Check redirect URI matches Supabase callback URL

---

*Created by Rufus for SwipeBase Cloud*
