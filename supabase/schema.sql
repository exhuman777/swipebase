-- SwipeBase Supabase Schema
-- Run this in Supabase SQL Editor

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ============================================
-- DECKS TABLE
-- ============================================
create table public.decks (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  description text,
  source text, -- 'upload', 'url', 'manual'
  item_count integer default 0,
  share_id text unique, -- for public sharing
  is_public boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Index for faster queries
create index decks_user_id_idx on public.decks(user_id);
create index decks_share_id_idx on public.decks(share_id);

-- ============================================
-- CARDS TABLE
-- ============================================
create table public.cards (
  id uuid default uuid_generate_v4() primary key,
  deck_id uuid references public.decks(id) on delete cascade not null,
  data jsonb not null, -- all card fields stored as JSON
  position integer default 0, -- for ordering
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Index for faster queries
create index cards_deck_id_idx on public.cards(deck_id);

-- ============================================
-- DECISIONS TABLE
-- ============================================
create table public.decisions (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  deck_id uuid references public.decks(id) on delete cascade not null,
  card_id uuid references public.cards(id) on delete cascade not null,
  decision text not null check (decision in ('like', 'maybe', 'pass')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, card_id) -- one decision per user per card
);

-- Index for faster queries
create index decisions_user_deck_idx on public.decisions(user_id, deck_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
alter table public.decks enable row level security;
alter table public.cards enable row level security;
alter table public.decisions enable row level security;

-- DECKS POLICIES
-- Users can view their own decks
create policy "Users can view own decks"
  on public.decks for select
  using (auth.uid() = user_id);

-- Users can view public decks via share_id
create policy "Anyone can view public decks"
  on public.decks for select
  using (is_public = true);

-- Users can insert their own decks
create policy "Users can create decks"
  on public.decks for insert
  with check (auth.uid() = user_id);

-- Users can update their own decks
create policy "Users can update own decks"
  on public.decks for update
  using (auth.uid() = user_id);

-- Users can delete their own decks
create policy "Users can delete own decks"
  on public.decks for delete
  using (auth.uid() = user_id);

-- CARDS POLICIES
-- Users can view cards from their own decks
create policy "Users can view own deck cards"
  on public.cards for select
  using (
    exists (
      select 1 from public.decks
      where decks.id = cards.deck_id
      and decks.user_id = auth.uid()
    )
  );

-- Anyone can view cards from public decks
create policy "Anyone can view public deck cards"
  on public.cards for select
  using (
    exists (
      select 1 from public.decks
      where decks.id = cards.deck_id
      and decks.is_public = true
    )
  );

-- Users can insert cards to their own decks
create policy "Users can add cards to own decks"
  on public.cards for insert
  with check (
    exists (
      select 1 from public.decks
      where decks.id = cards.deck_id
      and decks.user_id = auth.uid()
    )
  );

-- Users can delete cards from their own decks
create policy "Users can delete own deck cards"
  on public.cards for delete
  using (
    exists (
      select 1 from public.decks
      where decks.id = cards.deck_id
      and decks.user_id = auth.uid()
    )
  );

-- DECISIONS POLICIES
-- Users can view their own decisions
create policy "Users can view own decisions"
  on public.decisions for select
  using (auth.uid() = user_id);

-- Users can insert their own decisions
create policy "Users can create decisions"
  on public.decisions for insert
  with check (auth.uid() = user_id);

-- Users can update their own decisions
create policy "Users can update own decisions"
  on public.decisions for update
  using (auth.uid() = user_id);

-- Users can delete their own decisions
create policy "Users can delete own decisions"
  on public.decisions for delete
  using (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to update deck item count
create or replace function update_deck_item_count()
returns trigger as $$
begin
  if TG_OP = 'INSERT' then
    update public.decks
    set item_count = item_count + 1,
        updated_at = now()
    where id = NEW.deck_id;
  elsif TG_OP = 'DELETE' then
    update public.decks
    set item_count = item_count - 1,
        updated_at = now()
    where id = OLD.deck_id;
  end if;
  return null;
end;
$$ language plpgsql security definer;

-- Trigger for item count
create trigger update_deck_count
  after insert or delete on public.cards
  for each row execute function update_deck_item_count();

-- Function to generate unique share ID
create or replace function generate_share_id()
returns text as $$
declare
  chars text := 'abcdefghijklmnopqrstuvwxyz0123456789';
  result text := '';
  i integer;
begin
  for i in 1..8 loop
    result := result || substr(chars, floor(random() * length(chars) + 1)::integer, 1);
  end loop;
  return result;
end;
$$ language plpgsql;

-- ============================================
-- STORAGE BUCKET (optional, for file uploads)
-- ============================================
-- Run in Supabase Dashboard > Storage > Create Bucket
-- Name: deck-files
-- Public: false

-- Storage policies (run after creating bucket)
-- insert into storage.buckets (id, name, public) values ('deck-files', 'deck-files', false);

-- create policy "Users can upload to own folder"
--   on storage.objects for insert
--   with check (
--     bucket_id = 'deck-files' and
--     auth.uid()::text = (storage.foldername(name))[1]
--   );

-- create policy "Users can view own files"
--   on storage.objects for select
--   using (
--     bucket_id = 'deck-files' and
--     auth.uid()::text = (storage.foldername(name))[1]
--   );
