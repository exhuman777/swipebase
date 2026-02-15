```
███████╗██╗    ██╗██╗██████╗ ███████╗██████╗  █████╗ ███████╗███████╗
██╔════╝██║    ██║██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝
███████╗██║ █╗ ██║██║██████╔╝█████╗  ██████╔╝███████║███████╗█████╗  
╚════██║██║███╗██║██║██╔═══╝ ██╔══╝  ██╔══██╗██╔══██║╚════██║██╔══╝  
███████║╚███╔███╔╝██║██║     ███████╗██████╔╝██║  ██║███████║███████╗
╚══════╝ ╚══╝╚══╝ ╚═╝╚═╝     ╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
```

<p align="center">
  <strong>SwipeBase</strong>
</p>

<p align="center">
  <em>Swipe Through Any Data, Tinder-Style</em>
</p>

<p align="center">
  <a href="swipebase.html">Lite</a> &middot;
  <a href="swipebase-cloud.html">Cloud</a> &middot;
  <a href="swipebase-docs.html">Docs</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/deps-Zero%20Dependencies-purple" alt="Zero Dependencies" />
  <img src="https://img.shields.io/badge/input-CSV%20/%20JSON%20/%20MD-brightgreen" alt="CSV / JSON / MD" />
  <img src="https://img.shields.io/badge/cloud-Supabase%20Sync-blue" alt="Supabase Sync" />
  <img src="https://img.shields.io/badge/deploy-Vercel-orange" alt="Vercel" />
</p>

---

**Import any dataset. Swipe right to keep, left to skip.**

Tinder-style review UI for datasets. Import CSV, JSON, or Markdown. Swipe cards left/right to categorize. Export filtered results. Optional Supabase cloud sync for team collaboration.

---

## File Map

```
  swipebase/
  README.md
  package.json
  swipebase-cloud.html
  swipebase-docs.html
  swipebase.html
  vercel.json
  supabase/
    SETUP.md
    schema.sql
```

---

Swipe through any data. Tinder-style review UI for datasets.

## Features

- **Import**: CSV, JSON, Markdown
- **Export**: CSV, JSON, Excel, Markdown
- **Swipe**: Yes/No/Maybe decisions with keyboard + touch gestures
- **Cloud**: Auth + persistence via Supabase (optional)
- **Share**: Public deck links

## Versions

| File | Description |
|------|-------------|
| `swipebase-cloud.html` | Full version with Supabase auth + cloud sync |
| `swipebase.html` | Lite version, client-side only, no backend |
| `swipebase-docs.html` | Documentation |

## Deploy

### Vercel (recommended)

```bash
vercel --prod
```

Routes:
- `/` - Cloud version (auth + sync)
- `/lite` - Lite version (no auth)
- `/docs` - Documentation

### Self-host

```bash
npx serve . -p 3000
```

## Supabase Setup

1. Create project at [supabase.com](https://supabase.com)
2. Run `supabase/schema.sql` in SQL Editor
3. Update credentials in `swipebase-cloud.html`:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Enable Google OAuth (optional) in Auth settings

See `supabase/SETUP.md` for detailed instructions.

## Stack

- Vanilla JavaScript (no frameworks)
- Single HTML files (self-contained)
- Supabase (auth, database, storage)

## License

MIT

---

Built by [exhuman777](https://github.com/exhuman777)
