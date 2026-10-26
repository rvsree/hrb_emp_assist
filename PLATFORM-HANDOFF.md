# Platform hand-off - start here

Read this first if you (human or a fresh Claude Code session) just opened
`hrb_emp_assist` or any one of its 7 child folders and don't have context
from the conversations that built this structure. This file is about the
**reorganization itself** - the 7-repo folder restructure, the cross-repo
diagrams, and the README overhaul done in 2026-10. It does not replace any
child repo's own history doc (e.g. `hrb_chatbot_service/docs/agent-reference/HANDOFF.md`,
written 2026-09-08, covers that repo's own RAG build - still the right
place for that repo's own deep history).

## What `hrb_emp_assist` is

A plain parent folder, created 2026-10-24, holding 7 previously-sibling
repos as children so they can be opened together (one VS Code window) or
individually, with no change to any of their own git history or GitHub
remotes. **`hrb_emp_assist` itself is NOT a git repo** - this was a
deliberate pause, not an oversight (see "Open decisions" below).

| Child folder | What it is | Branch | Uncommitted | Remote |
|---|---|---|---|---|
| `hrb_chatbot_service` | FastAPI RAG backend - the main project | `feature-hrb-chatbot-subdomain` | 14 | `github.com/rvsree/hrb_chatbot_service` |
| `hrb_chatbot_ui` | React/TS frontend | `master` | 8 | `github.com/rvsree/hrb_chatbot_ui` |
| `hrb_api_gateway_service` | API gateway microservice | `master` | 1 | `github.com/rvsree/hrb_api_gateway_service` |
| `rag_ingestion_service` | Ingestion pipeline (Lambda-based) | `master` | 1 | `github.com/rvsree/rag_ingestion_service` |
| `rag_retrieval_service` | Retrieval microservice | `master` | 1 | `github.com/rvsree/rag_retrieval_service` |
| `hrb_platform_components` | Shared platform infra | `master` | 1 | `github.com/rvsree/hrb_platform_components` |
| `hrb-common-libs` | Shared Python library (11 real extras) | `master` | 1 | `github.com/rvsree/hrb-common-libs` |

Each one is a fully independent git working copy - its history, branches,
and GitHub connection are unaffected by living inside `hrb_emp_assist`.

## How this folder came to exist - what was done, in order

1. Color-readability fix across existing `.drawio` architecture diagrams
   (white box backgrounds, color moved to borders only, text normalized to
   `#262B36`).
2. Built a full set of current-state / target-state(scaling) / deployment
   `.drawio` diagrams for all 7 apps, one app at a time (MVP pilot:
   `hrb_api_gateway_service` first), all under
   `hrb_chatbot_service/docs/dev-reference/hrb_chatbot_v3/architecture/diagrams/`,
   indexed by that folder's own `README.md`.
3. Registered `hrb_api_gateway_service`'s docs/diagrams in
   `hrb_chatbot_service/scripts/sync_admin_docs.py` - **written, not yet
   run** (needs explicit go-ahead; see "Open decisions").
4. Overhauled all 7 repos' own `README.md` files, FDE-style (quickstart,
   docs index, "for reviewers" fast path), cross-linking the new diagrams.
   Full rewrites: `hrb_api_gateway_service`, `rag_ingestion_service`,
   `rag_retrieval_service`, `hrb_platform_components`, `hrb-common-libs`.
   Light-touch additions only: `hrb_chatbot_service`, `hrb_chatbot_ui`.
5. Created this parent folder and copied/moved all 7 repos into it as
   children (6 moved directly; `hrb_chatbot_service` needed a **manual
   copy by the user** - this session's own shell is bound to that folder
   as its project root for its whole lifetime and can't move/rename it;
   confirmed intact 2026-10-24: same file count, same git log, same
   remote, same 14 uncommitted files as the original).
6. Set up the full `.claude/` SDD scaffold (`CLAUDE.md`, `ROADMAP.md`,
   hooks, skills, agents) for `hrb_chatbot_ui` - it was the one repo of
   the 6 that had none. No fabricated phase history was written; everything
   before 2026-10-25 is marked "pre-SDD, real and shipped, not tracked."
7. **A separate, later session (2026-10-26)** ran an MVP-1 through MVP-6
   build against this `hrb_emp_assist` copy specifically - `hrb_chatbot_service`
   Phases 256-260 (judge-provider selection, the generic `app_settings`/
   `live_query_store`/`synthetic_dataset_store`, routing-accuracy scoring, the
   generic Redis `CircuitBreaker`), `hrb_chatbot_ui`'s own Phase 1 (Settings +
   Live Queries + Synthetic Dataset tabs), and 4 new diagrams (3 under
   `hrb_chatbot_service/docs/dev-reference/hrb_chatbot_v3/` - state
   management, conversational-memory STM/LTM, tool-call-audit/routing-accuracy
   - plus `docs/architecture/platform-current-vs-target-state.html` at this
   parent level). See `hrb_chatbot_service/docs/agent-reference/RAG-ROADMAP.md`'s
   Phase 256-260 entries for the detailed build notes.

## Cost control - all 6 App Runner services pause by default

Added 2026-10-25: all 6 services were running continuously (~$170/month
estimated - App Runner doesn't scale to zero on its own). Now **paused**
by default. `scripts/apprunner-switch.sh {pause|resume|status}` is the
switch - `resume` before a demo/interview (~1-2 min to come back), `pause`
after. A $20/month AWS Budget (`hrb-platform-monthly`) alerts by email at
50/80/100% as a safety net. Neon Postgres idles on its own separate
schedule, unrelated to this script.

## Open decisions - nothing here blocks continuing work

1. **Resolved, 2026-10-26: `hrb_emp_assist` has its own git repo and a
   private GitHub remote** (`github.com/rvsree/hrb_emp_assist`, confirmed
   live via `gh repo view`). Each child repo still keeps its own separate
   git/GitHub, unaffected.
2. **The original `hrb_chatbot_service` folder still exists** at
   `C:\workspace\2026-v1\interview-kickstart\hrb_chatbot_service` - step 5
   was a *copy*, not a move (this session couldn't move its own project
   root). Decide whether to delete the original once you've confirmed
   you're working from the `hrb_emp_assist` copy going forward - don't
   delete it from a Claude Code session without saying so explicitly first.
   **Update, 2026-10-26:** the two copies have since diverged further, in
   both directions - confirmed by directly listing both, not assumed. The
   original has `docs/dev-reference/hrb_chatbot_v3/architecture/platform-overview.html`
   and a new `architecture/diagrams/` folder that the `hrb_emp_assist` copy
   does not. The `hrb_emp_assist` copy has all of MVP-1 through MVP-5's
   real work (Phases 256-260: `app_settings`/`live_query_store`/
   `synthetic_dataset_store`, the generic `CircuitBreaker`, routing-accuracy
   scoring, `docs/agent-reference/testing-strategies.md`, `hrb_chatbot_ui`'s
   new Settings/Live Queries/Synthetic Dataset tabs) that the original does
   not. User confirmed 2026-10-26: `hrb_emp_assist` is the copy to keep
   working from going forward - the original's extra docs/diagrams still
   need manually porting over or re-deciding, not done automatically.
3. **Fixed, 2026-10-26.** 513 hardcoded `file:///C:/workspace/2026-v1/
   interview-kickstart/hrb_chatbot_service/...` references across 86 HTML
   files rewritten to the correct `hrb_emp_assist/`-prefixed path - most
   needed more than just that prefix insertion, since many docs also moved
   during the 2026-10-23 child-repo reorg and the 2026-10-26 platform/
   service doc split (e.g. several `deployment-guide/*.html` files moved
   from `hrb_chatbot_service` up to this parent's own `docs/`). Resolved
   mechanically (same-directory sibling match, then folder-name narrowing),
   not guessed - every one of the 513 rewritten links verified afterward to
   point at a real, existing file.
4. **VS Code multi-root `.code-workspace` file** - identified as the right
   tool for "one entry point, still able to open any child alone," not yet
   built.
5. **`python -m scripts.sync_admin_docs`** (in `hrb_chatbot_service`) never
   run - would push the newly-registered `hrb_api_gateway_service` docs/
   diagrams to the live S3 bucket + `doc_metadata` table. Gated behind the
   project's own "nothing pushed/deployed without explicit go-ahead" norm.

## Standing norms that apply across all 7 repos

- **No commits** across any of these repos right now - the user is doing a
  manual review pass first ("let me manually review all these files and
  make manual edits where needed," said 2026-10-24). Wait for them to ask
  before committing anything touched during this reorg.
- **Nothing gets pushed/deployed/synced to AWS** without explicit local
  review + go-ahead, every time - this is `hrb_chatbot_service/CLAUDE.md`'s
  norm, treated as applying platform-wide here too.
- For anything repo-specific, that repo's own `CLAUDE.md` is the authority
  - this file only covers the cross-repo reorg, not any single repo's
  architecture or conventions.

## For the user's own manual action items

See `sree-handoff.md` in this same folder - plain-language checklist, not
meant for a Claude session to act on automatically.

## Session reference - the conversation that wrote this file

Claude Code keeps each session's raw transcript on disk, keyed by the
project directory it was launched from plus a UUID. This file was written
during a session launched from `hrb_chatbot_service` (its *old* location,
before the move), so its transcript sits under that project's own storage
folder, not `hrb_emp_assist`'s:

- Project folder key: `c--workspace-2026-v1-interview-kickstart-hrb-chatbot-service`
- Session UUID: `fa6afd78-1962-4d19-8fbd-ad28ae9278a7`
- Full path: `C:\Users\sreed\.claude\projects\c--workspace-2026-v1-interview-kickstart-hrb-chatbot-service\fa6afd78-1962-4d19-8fbd-ad28ae9278a7.jsonl`

This is the full raw log of the conversation that did the color-fix,
7-app diagram build, README overhaul, and `hrb_emp_assist` reorg - useful if
you need to recover exact reasoning/detail that didn't make it into this
summary. A session launched from `hrb_emp_assist` or any other child folder
going forward will get its own, different project-folder key and UUID -
this reference is specific to this one conversation, not a general lookup
pattern.
