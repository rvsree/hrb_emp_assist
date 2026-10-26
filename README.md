# hrb_emp_assist

Parent project for the HRB (HR Benefits) chatbot platform — an HR benefits
assistant built as an Interview Kickstart FDE (Forward Deployed Engineer)
capstone, grown from a single monolith into a real 8-component system.
This folder holds 7 of those components as independent git repos (each with
its own GitHub remote and history, unaffected by living here), plus the
platform-level documentation that spans more than one of them.

## For reviewers (5 minutes)

Written for someone picking this up cold — a reviewer, a new engineer, or
the actual audience this whole project is built for: a Forward Deployed
Engineer walking into an unfamiliar system and needing to get oriented
fast, not just read about it.

1. [docs/architecture/platform-overview.html](docs/architecture/platform-overview.html) —
   the one page to start from: every business capability, which of the 8
   real repos realizes it, one diagram tying it together, links into every
   component's own detailed docs.
2. The capability table and repo table below — same information, in plain
   markdown, if you'd rather not open an HTML file.
3. [docs/architecture/diagrams/README.md](docs/architecture/diagrams/README.md) —
   every current-state, target-state (scaling), and deployment diagram,
   indexed, as real editable `.drawio` files, not static images.
4. [PLATFORM-HANDOFF.md](PLATFORM-HANDOFF.md) — if you're picking this up
   with no prior context, written for exactly that.

## What this platform actually does

| Capability | What it means | Status |
|---|---|---|
| Benefits Q&A (RAG chat) | Ask about 401(k), healthcare, tuition, leave or disability policy, get an answer grounded in the real HR knowledge base — 3 interchangeable modes (direct retrieve+generate, single ReAct agent, multi-agent planner+reviewer) | Live |
| Live HR data lookup | "What's my leave balance?" — answered via a real tool call to live data, not a static document | Live |
| Unpaid-leave request (HITL) | A real multi-day approval workflow — request submitted, a manager approves days later by email, the conversation resumes exactly where it left off | Live |
| Document ingestion | HR uploads a benefits PDF; it's chunked, embedded, indexed so the next question can be answered from it | Live |
| Admin & platform ops | CI/CD pipeline visibility across all repos, golden-dataset viewer, eval-run history, live metrics, Interview Q&A editor | Live |
| 401(k) loan guidance | A hub/sub-agent router (loan, withdrawal, transfer, retirement), reusing the planner→domain-agents pattern already proven in multi-agentic-rag | Design only |
| Voice front door | Speech in, speech out — a transcription/synthesis wrapper in front of the existing chat capabilities | Design only |

## The 8 components

| Repo | Role | Status |
|---|---|---|
| `hrb_chatbot_ui` | Frontend SPA (React) | Live |
| `hrb_api_gateway_service` | Single public entry point — CORS, rate limiting, contract validation | Live |
| `hrb_chatbot_service` | Pre-split monolith; still the real retrieval backend in production today | Live |
| `rag_ingestion_service` | Extract → chunk → embed → index, sync + async paths | Live, cut over |
| `rag_retrieval_service` | Decompose → retrieve → generate | Live, standalone (not yet cut over) |
| `hrb_platform_components` | CI/CD dashboard, Interview Q&A, MCP tool catalog | Live |
| `hrb-common-libs` | Shared connectors (observability/db/cache/auth/etc.), pip-installed via git tag | In use |
| `hrb_lms_mcp` | Separate project — real leave/HR data, its own OAuth2 — not part of this parent folder | Live |

Full detail, real resource identifiers, and the honest current-vs-target gap
for each one: [docs/architecture/platform-overview.html](docs/architecture/platform-overview.html).

## Documentation map

**Split 2026-10-26**: platform-level docs (span more than one repo) live
here, under `docs/`. Service-specific docs stay inside each repo's own
`docs/` folder.

| Here (platform-level) | What's in it |
|---|---|
| `docs/architecture/` | System/platform overview, microservices interface matrix and rollout plan, service-boundary decisions, DB model overview |
| `docs/architecture/diagrams/` | Every service's current-state, target-state, and deployment `.drawio` diagrams, indexed |
| `docs/auth/` | OAuth2 architecture (app-to-app, real; human-to-app, design), separate auth-server scope |
| `docs/platform-and-admin/` | Docs for `hrb_api_gateway_service`, `hrb-common-libs`, `hrb_platform_components` — hosted here since those repos' own docs are centralized |
| `docs/deployment-and-ops/build-and-deploy/` | Build + deployment architecture for every one of the 7 repos |
| [docs/observability-governance.md](docs/observability-governance.md) | Which services have real LangSmith tracing vs. just scaffolded env vars, and what tracing data does (and doesn't) support for audit/governance |

| Per-repo (service-specific) | Where |
|---|---|
| RAG pipeline internals, agents/workflows, guardrails/evaluation, this repo's own deploy/monitoring loop | `hrb_chatbot_service/docs/dev-reference/hrb_chatbot_v3/` |
| SDD process history (phase-by-phase roadmap, backlog, coding standards) | `hrb_chatbot_service/docs/agent-reference/` |
| Each other repo's own build/run instructions | That repo's own `README.md` |

## Operating this platform

- **Cost control**: all AWS App Runner services pause by default — `scripts/apprunner-switch.sh {pause|resume|status}`. Resume before a demo, pause after. See [PLATFORM-HANDOFF.md](PLATFORM-HANDOFF.md) for the full cost-control story (an AWS Budget alert and a LangSmith spend limit are also in place).
- **Observability**: traces at [smith.langchain.com](https://smith.langchain.com) (`hrb_chatbot_service_prod` / `hrb_chatbot_service_local`), app logs in CloudWatch (`/aws/apprunner/hrb-chatbot/.../application`).
- **Manual action items**: [sree-handoff.md](sree-handoff.md) — a plain checklist of things only a human can decide or do (not auto-actioned).

## Functional vs non-functional status — where this platform is, honestly

This project tracks its own gaps openly rather than only showing what's
done. A full, sequenced breakdown of what's built vs planned (datasets,
observability/governance, resiliency, memory architecture, and more) lives
in the working session history — ask for the latest status table, or see
`PLATFORM-HANDOFF.md`'s "Open decisions" section for the standing list.

## Status

Reorganized 2026-10-24 into this parent-folder structure; platform-level
docs split out 2026-10-26. Each of the 7 child repos is independently
deployed and versioned — see each one's own `README.md` for its specific
build/run/test instructions. This parent folder itself is a separate,
private GitHub repo ([github.com/rvsree/hrb_emp_assist](https://github.com/rvsree/hrb_emp_assist)),
tracking only its own root-level files — the 7 child folders are
deliberately `.gitignore`d here since each has its own remote already.
