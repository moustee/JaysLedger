-- Run this in the Supabase SQL Editor for the Jays Ledger app.
-- Each authenticated Supabase user can access only their own account row.

create table if not exists public.accounts (
  phone text primary key,
  user_id uuid not null unique references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.accounts enable row level security;

revoke all on table public.accounts from anon;
grant select, insert, update, delete on table public.accounts to authenticated;

drop policy if exists "Users can read their own ledger" on public.accounts;
create policy "Users can read their own ledger"
  on public.accounts for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users can create their own ledger" on public.accounts;
create policy "Users can create their own ledger"
  on public.accounts for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users can update their own ledger" on public.accounts;
create policy "Users can update their own ledger"
  on public.accounts for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users can delete their own ledger" on public.accounts;
create policy "Users can delete their own ledger"
  on public.accounts for delete to authenticated
  using (auth.uid() = user_id);
