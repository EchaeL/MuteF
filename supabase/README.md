# Supabase

MuteF 사이트가 쓰는 Supabase 프로젝트(MuteFweb)의 데이터베이스 설정.

- `migrations/` — 표와 접근 규칙을 만드는 SQL. `main`에 push하면 Supabase GitHub 연동(Deploy to production)이 순서대로 적용함.
- 새 변경은 기존 파일을 고치지 말고 `YYYYMMDDHHMMSS_설명.sql` 이름으로 새 파일을 추가할 것.

## 표

| 표 | 쓰는 곳 | 내용 |
| --- | --- | --- |
| `events` | `calender.html` | 일정 (제목, 날짜, 장소 이름/링크, 참여 인원, 메모) |

공개(publishable) 키로는 `events`를 읽기·추가만 할 수 있음. 수정·삭제는 막혀 있음.
