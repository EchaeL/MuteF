-- 일정(calender.html) 저장용 표
create table if not exists public.events (
  id          uuid primary key default gen_random_uuid(),
  title       text not null check (char_length(title) between 1 and 100),
  date        date not null,
  place_name  text not null default '',
  place_link  text not null default '',
  members     text[] not null default '{}',
  memo        text not null default '',
  created_at  timestamptz not null default now()
);

create index if not exists events_date_idx on public.events (date);

-- 지금 사이트에는 진짜 로그인이 없어서, 공개 키(publishable/anon)로 읽기·추가만 허용.
-- 수정·삭제는 막아 둠. 나중에 Supabase 로그인을 붙이면 이 규칙을 좁힐 것.
alter table public.events enable row level security;

drop policy if exists "events_read" on public.events;
create policy "events_read" on public.events
  for select to anon, authenticated
  using (true);

drop policy if exists "events_insert" on public.events;
create policy "events_insert" on public.events
  for insert to anon, authenticated
  with check (true);

grant select, insert on public.events to anon, authenticated;
