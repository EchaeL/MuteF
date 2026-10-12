-- ID별 프로필 사진 (사이드바 프로필, 타임라인)
create table if not exists public.profiles (
  id           text primary key check (char_length(id) between 1 and 50),   -- MuteF ID
  avatar_path  text not null default '',                                    -- avatars 보관함 안 경로, ''면 기본 이미지
  updated_at   timestamptz not null default now()
);

-- 지금 사이트에는 진짜 로그인이 없어서 공개 키로 읽기·쓰기를 허용.
-- "자기 프로필만 변경"은 화면에서만 막고 있음. 나중에 Supabase 로그인을 붙이면 좁힐 것.
alter table public.profiles enable row level security;

drop policy if exists "profiles_read" on public.profiles;
create policy "profiles_read" on public.profiles
  for select to anon, authenticated using (true);

drop policy if exists "profiles_insert" on public.profiles;
create policy "profiles_insert" on public.profiles
  for insert to anon, authenticated with check (true);

drop policy if exists "profiles_update" on public.profiles;
create policy "profiles_update" on public.profiles
  for update to anon, authenticated using (true) with check (true);

grant select, insert, update on public.profiles to anon, authenticated;

-- 프로필 사진 보관함 (공개 읽기, 2MB 이하 이미지만)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('avatars', 'avatars', true, 2097152,
        array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

drop policy if exists "avatars_read" on storage.objects;
create policy "avatars_read" on storage.objects
  for select to anon, authenticated using (bucket_id = 'avatars');

drop policy if exists "avatars_insert" on storage.objects;
create policy "avatars_insert" on storage.objects
  for insert to anon, authenticated with check (bucket_id = 'avatars');

drop policy if exists "avatars_delete" on storage.objects;
create policy "avatars_delete" on storage.objects
  for delete to anon, authenticated using (bucket_id = 'avatars');
