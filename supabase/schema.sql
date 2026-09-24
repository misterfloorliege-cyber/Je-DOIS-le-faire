-- Schéma Supabase pour Je DOIS le faire
create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(), user_id uuid references auth.users not null,
 title text not null, project text default 'Nouveau projet', category text check (category in ('Professionnel','Privé')) default 'Professionnel',
 priority text check (priority in ('Prioritaire','Élevée','Normale')) default 'Normale', completed boolean default false, created_at timestamptz default now()
);
create table if not exists public.time_entries (
 id uuid primary key default gen_random_uuid(), user_id uuid references auth.users not null, task_id uuid references public.tasks,
 started_at timestamptz not null, ended_at timestamptz, duration_seconds integer default 0, note text, created_at timestamptz default now()
);
alter table public.tasks enable row level security; alter table public.time_entries enable row level security;
create policy "Users manage their tasks" on public.tasks for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage their time" on public.time_entries for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
