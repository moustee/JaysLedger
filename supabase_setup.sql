-- Run once in Supabase Dashboard > SQL Editor
create table if not exists public.ledger_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.ledger_data enable row level security;

drop policy if exists "read own ledger"   on public.ledger_data;
drop policy if exists "insert own ledger" on public.ledger_data;
drop policy if exists "update own ledger" on public.ledger_data;
drop policy if exists "delete own ledger" on public.ledger_data;

create policy "read own ledger"   on public.ledger_data for select to authenticated using ((select auth.uid()) = user_id);
create policy "insert own ledger" on public.ledger_data for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "update own ledger" on public.ledger_data for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "delete own ledger" on public.ledger_data for delete to authenticated using ((select auth.uid()) = user_id);
