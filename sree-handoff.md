# Sree's hand-off notes - manual action items

Personal reference, written 2026-10-24. Things only you can do - account
actions, decisions, or physical cleanup - not things to hand back to
Claude Code. Check items off as you do them; this file won't update
itself.

## Decide

- [ ] **Parent-repo question.** `hrb_emp_assist` has no git of its own
  right now. Each of the 7 child folders keeps its own independent git
  history and GitHub remote regardless - that part is already fine and
  needs no decision. The only open question is whether you *also* want a
  brand-new, separate GitHub repo for `hrb_emp_assist` itself (to hold a
  top-level README about the whole platform, or cross-repo scripts). Not
  needed unless you have a specific use for it.
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

- [ ] Fix 88 absolute-path references in HTML docs that still point at the
  old `hrb_chatbot_service` location (need `hrb_emp_assist/` inserted).
- [ ] Build a VS Code `.code-workspace` file at `hrb_emp_assist/` root for
  the "open everything at once, or any one alone" setup you asked for.
- [ ] Run `python -m scripts.sync_admin_docs` from inside `hrb_chatbot_service`
  (from the `hrb_emp_assist` copy) to actually push the new
  `hrb_api_gateway_service` docs/diagrams to S3 + the `doc_metadata` table.
  Say go-ahead explicitly when you want this to happen - it changes what's
  live.

## Already resolved, no action needed

- All 7 repos are in `hrb_emp_assist` now, each verified intact.
- `hrb_chatbot_ui`'s SDD scaffold is set up and matches the other repos'
  pattern.
- Cross-session context for a future Claude session: see
  `PLATFORM-HANDOFF.md` in this same folder.
