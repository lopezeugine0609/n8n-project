# n8n Workflows

Version-controlled n8n workflow exports, with a local n8n and PostgreSQL stack for building and testing them. Workflows are stored as separate JSON files in `workflows/`; credentials are never exported into this repository.

## Start

1. Copy `.env.example` to `.env`.
2. Set `POSTGRES_PASSWORD` to a unique password and `N8N_ENCRYPTION_KEY` to a long random value. Keep `.env` private; losing the encryption key can make stored credentials unreadable.
3. Start the services:

   ```powershell
   docker compose up -d
   ```

4. Open [http://localhost:5678](http://localhost:5678) and create the n8n owner account. The editor is bound to `127.0.0.1` and is available only from this machine by default.

## Workflow library

- Build and test workflows in the local editor.
- Export all workflows as individual JSON files with `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\export-workflows.ps1`.
- Review the JSON changes, then commit and push them with Git.
- Import repository workflows into the local instance with `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\import-workflows.ps1`. Imports are inactive by default; review them in n8n before activating.
- Validate workflow JSON files with `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-workflows.ps1`. GitHub Actions runs the same validation for pushes and pull requests.

n8n does not compile workflows into binaries: this repository versions the native workflow JSON exports. Keep API keys and credentials in n8n's credential store, never in workflow JSON or Git.

### Part-time automation job review

`workflows/part-time-automation-job-review.json` checks Remotive once daily at 9 AM UTC (or on a manual run), keeps only part-time listings related to automation, n8n, workflow tooling, RPA, Zapier, or Make, and produces a review item with the original listing link and a cover-note draft containing explicit profile placeholders. New listings are deduplicated for 45 days. The workflow is imported inactive; review and activate it in n8n. Results appear in the execution data. Remotive asks API users to keep request volume low and link to the original listing, so the workflow makes one request per day and preserves the Remotive link/source.

LinkedIn, Indeed, and Wellfound are not queried by this starter workflow. It does not scrape logged-in sites or submit applications. Add those sources only through their permitted APIs/integrations. Tailored application drafts need your accurate resume/profile details, and every application should be reviewed before you submit it.

Check service status with `docker compose ps` and logs with `docker compose logs -f n8n`. Stop the services with `docker compose down`; workflow data remains in the named volumes. Do not use `docker compose down -v` unless you intend to permanently delete the database and n8n data.

## Public deployment

This configuration is local-only. Before exposing n8n publicly, put it behind HTTPS with a reverse proxy, configure `N8N_HOST`, `N8N_PROTOCOL`, `N8N_EDITOR_BASE_URL`, and `WEBHOOK_URL` for the public hostname, and set `N8N_SECURE_COOKIE=true`. Do not publish port 5678 directly to the internet.