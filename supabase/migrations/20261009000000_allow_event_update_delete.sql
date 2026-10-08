-- 일정 수정·삭제 허용 (calender.html의 일정 목록 팝업 ⋮ 메뉴)
-- 지금 사이트에는 진짜 로그인이 없어서 공개 키로 누구나 수정·삭제할 수 있음.
-- 나중에 Supabase 로그인을 붙이면 이 규칙을 좁힐 것.

drop policy if exists "events_update" on public.events;
create policy "events_update" on public.events
  for update to anon, authenticated
  using (true)
  with check (true);

drop policy if exists "events_delete" on public.events;
create policy "events_delete" on public.events
  for delete to anon, authenticated
  using (true);

grant update, delete on public.events to anon, authenticated;
