-- Members 게시물 (members.html)
create table if not exists public.posts (
  id          uuid primary key default gen_random_uuid(),
  author      text not null check (char_length(author) between 1 and 50),
  title       text not null default '' check (char_length(title) <= 100),
  image_path  text not null default '',
  pinned      boolean not null default false,   -- 대표 게시물
  created_at  timestamptz not null default now()
);

create index if not exists posts_author_idx on public.posts (author, created_at desc);

-- 지금 사이트에는 진짜 로그인이 없어서 공개 키로 읽기·쓰기를 모두 허용.
-- "자기 피드만 수정"은 화면에서만 막고 있음. 나중에 Supabase 로그인을 붙이면 좁힐 것.
alter table public.posts enable row level security;

drop policy if exists "posts_read" on public.posts;
create policy "posts_read" on public.posts
  for select to anon, authenticated using (true);

drop policy if exists "posts_insert" on public.posts;
create policy "posts_insert" on public.posts
  for insert to anon, authenticated with check (true);

drop policy if exists "posts_update" on public.posts;
create policy "posts_update" on public.posts
  for update to anon, authenticated using (true) with check (true);

drop policy if exists "posts_delete" on public.posts;
create policy "posts_delete" on public.posts
  for delete to anon, authenticated using (true);

grant select, insert, update, delete on public.posts to anon, authenticated;

-- 게시물 사진 보관함 (공개 읽기, 5MB 이하 이미지만)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('post-images', 'post-images', true, 5242880,
        array['image/jpeg', 'image/png', 'image/webp', 'image/gif'])
on conflict (id) do nothing;

drop policy if exists "post_images_read" on storage.objects;
create policy "post_images_read" on storage.objects
  for select to anon, authenticated using (bucket_id = 'post-images');

drop policy if exists "post_images_insert" on storage.objects;
create policy "post_images_insert" on storage.objects
  for insert to anon, authenticated with check (bucket_id = 'post-images');

drop policy if exists "post_images_delete" on storage.objects;
create policy "post_images_delete" on storage.objects
  for delete to anon, authenticated using (bucket_id = 'post-images');
