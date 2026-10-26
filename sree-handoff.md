# Sree's hand-off notes - manual action items

Personal reference, written 2026-10-24. Things only you can do - account
actions, decisions, or physical cleanup - not things to hand back to
Claude Code. Check items off as you do them; this file won't update
itself.

## Decide

- [x] **Parent-repo question.** Resolved: `hrb_emp_assist` has its own
  private GitHub repo now (`github.com/rvsree/hrb_emp_assist`, confirmed
  live 2026-10-26). Each of the 7 child folders still keeps its own
  independent git history and GitHub remote, unaffected.
- [ ] **Delete the original `hrb_chatbot_service` folder?** It's still
  sitting at `C:\workspace\2026-v1\interview-kickstart\hrb_chatbot_service`,
  a full duplicate of `hrb_emp_assist\hrb_chatbot_service` (confirmed
  identical: same file count, same git log, same remote, same 14
  uncommitted files). Decide once you've started working from the
  `hrb_emp_assist` copy day-to-day.

## Review (your own stated plan - "let me manually review all these files")

- [ ] 7 rewritten `README.md` files (5 full rewrites, 2 light-touch) - all
  currently uncommitted in their repos.
- [ ] 17 new/edited `.drawio` diagram files under
  `hrb_chatbot_service/docs/dev-reference/hrb_chatbot_v3/architecture/diagrams/`.
- [ ] `hrb_chatbot_service/scripts/sync_admin_docs.py`'s new
  `hrb_api_gateway_service` registry entry.
- [ ] `hrb_chatbot_ui`'s new `.claude/` scaffold + `CLAUDE.md` + `ROADMAP.md`
  (first time this repo has had one).
- [ ] `hrb_chatbot_service/docs/dev-reference/hrb_chatbot_v3/platform-and-admin/
  api-gateway-service/architecture.html`'s corrected RBAC-enforcement claim.

## Do, when ready (none urgent)

- [x] Fixed, 2026-10-26: all 513 stale `file:///...` references across 86
  HTML files rewritten to the correct `hrb_emp_assist/`-prefixed, post-reorg
  path - mechanically resolved (sibling/folder-name matching, not guessed)
  and every rewritten link verified to point at a real file. 0 unresolved.
- [ ] Build a VS Code `.code-workspace` file at `hrb_emp_assist/` root for
  the "open everything at once, or any one alone" setup you asked for.
- [ ] Run `python -m scripts.sync_admin_docs` from inside `hrb_chatbot_service`
  (from the `hrb_emp_assist` copy) to actually push the new
  `hrb_api_gateway_service` docs/diagrams to S3 + the `doc_metadata` table.
  Say go-ahead explicitly when you want this to happen - it changes what's
  live.

## Cost control - set up 2026-10-25

All 6 App Runner services (`hrb-chatbot`, `hrb-api-gateway`, `hrb-lms-mcp`,
`rag-ingestion-service`, `rag-retrieval-service`, `hrb-platform-components`)
were running 24/7, ~$170/month estimated. Now **paused** by default.

- **Before a demo/interview**: `scripts/apprunner-switch.sh resume` (1-2 min
  to come back up), confirm with `scripts/apprunner-switch.sh status`.
- **After you're done**: `scripts/apprunner-switch.sh pause` again.
- **Budget alert**: `hrb-platform-monthly`, $20/month cap, emails you at
  50/80/100% of actual spend.
- Neon Postgres may idle separately on its own schedule - unrelated to this
  script, give it a few seconds to wake on first query after a resume.

## Already resolved, no action needed

- All 7 repos are in `hrb_emp_assist` now, each verified intact.
- `hrb_chatbot_ui`'s SDD scaffold is set up and matches the other repos'
  pattern.
- Cross-session context for a future Claude session: see
  `PLATFORM-HANDOFF.md` in this same folder.
