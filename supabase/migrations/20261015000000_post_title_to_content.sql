-- 트위터처럼: 게시물 "제목" → "내용" (여러 줄, 최대 2000자)
do $$
begin
  if exists (select 1 from information_schema.columns
             where table_schema = 'public' and table_name = 'posts' and column_name = 'title') then
    alter table public.posts rename column title to content;
  end if;
end $$;

alter table public.posts drop constraint if exists posts_title_check;
alter table public.posts drop constraint if exists posts_content_check;
alter table public.posts
  add constraint posts_content_check check (char_length(content) <= 2000);
