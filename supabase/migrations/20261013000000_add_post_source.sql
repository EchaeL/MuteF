-- 게시물을 어디에 올렸는지: feed(피드 — 타임라인에도 보임) / timeline(타임라인에만 보임)
alter table public.posts
  add column if not exists source text not null default 'feed';

alter table public.posts
  drop constraint if exists posts_source_check;

alter table public.posts
  add constraint posts_source_check check (source in ('feed', 'timeline'));

create index if not exists posts_created_idx on public.posts (created_at desc);
