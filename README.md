# Deploy and Host OpenWA on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/openwa?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=openwa)

OpenWA is a free, open-source WhatsApp API gateway. You link a WhatsApp number by scanning a QR code, then send and receive messages over a REST API, webhooks and a WebSocket, and manage it all from a built-in dashboard. This template runs OpenWA 0.29.1 on Railway as one service with a generated admin key and a volume that keeps your sessions across redeploys.

This is a community template, not made or supported by the OpenWA project. OpenWA is not affiliated with WhatsApp or Meta.

## About Hosting OpenWA

The API and the dashboard run in the same container, on the same domain. Nothing else is needed: the database is SQLite on the volume.

**Sign in:** open your Railway domain and sign in with `API_MASTER_KEY`, which the template generates. Find it in the service's **Variables** tab. The same key works as the `X-API-Key` header for the API. It is set on the first boot only; to rotate it, create a new admin key in the dashboard and revoke the old one.

**Link a number:** in the dashboard create a session, start it, and scan the QR code with WhatsApp on your phone (**Linked devices**). The session is stored on the volume and reconnects by itself after a redeploy.

**Pick the engine for your plan:** `ENGINE_TYPE` decides how sessions connect.

- `whatsapp-web.js` (default) drives a real headless Chromium, which looks like normal WhatsApp Web traffic. One session brought the service to about 600 MB in our test, so it needs a plan with 1 GB or more, and roughly 400 MB for each extra session.
- `baileys` speaks the WhatsApp protocol directly with no browser. The whole service stayed near 200 MB with one session, so it fits a 0.5 GB plan, but WhatsApp detects it more easily.

**Know the risk:** OpenWA uses reverse-engineered WhatsApp clients, not Meta's official Cloud API. WhatsApp can restrict or ban numbers that use them, more readily from datacenter addresses like Railway's and when messaging people who never wrote to you. Use a number you can afford to lose, message people who expect it, and read the [risk guide](https://github.com/rmyndharis/OpenWA/blob/main/docs/16-risk-management.md) first.

## Common Use Cases

- Order updates, reminders and one-time codes sent to your own customers over WhatsApp
- Connecting WhatsApp to n8n, an AI agent or your own backend through webhooks and the REST API
- A shared support number, with API keys limited to chosen sessions or chats

## Dependencies for OpenWA Hosting

- None. SQLite, the dashboard and Chromium are included. PostgreSQL, Redis and S3 storage are optional.

### Deployment Dependencies

- [OpenWA on GitHub](https://github.com/rmyndharis/OpenWA)
- [OpenWA documentation](https://github.com/rmyndharis/OpenWA/tree/main/docs)
- [Risk guide](https://github.com/rmyndharis/OpenWA/blob/main/docs/16-risk-management.md)
- [Template source](https://github.com/two-workspaces/openwa)

### Implementation Details

- **Tested on Railway:** dashboard and API behind the generated key, requests without a key or with a wrong key refused, a session reaching the QR code on both engines, and sessions and keys surviving a redeploy. Memory was measured under 0.5 GB and 1 GB limits. Linking a real number and sending messages were not tested.
- **On a 0.5 GB plan** a `whatsapp-web.js` session fails to start with "Engine initialization timed out". The service itself stays up. Set `ENGINE_TYPE=baileys` and start the session again.
- **Changing the engine** later is possible, but a session linked on one engine has to be linked again on the other.
- **Your data** lives on the volume at `/app/data`: the SQLite database, session credentials and media. Turn on volume backups in the service's **Backups** tab.
- **PostgreSQL or Redis (optional):** the "built-in" datastore switches under **Infrastructure** in the dashboard need Docker and do nothing on Railway. Add a Railway Postgres or Redis service instead and set `DATABASE_TYPE=postgres` with `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME`, `DATABASE_PASSWORD` and `DATABASE_NAME`, or `REDIS_ENABLED=true` with the Redis variables from the docs.
- **Keep `API_KEY_PEPPER` as generated.** API keys are stored hashed with it. Changing or removing it locks out every key, the admin key included.
- **Client IPs:** `TRUSTED_PROXIES` is set to Railway's edge network, so per-key IP allowlists see the real caller.
- **Image:** upstream's `ghcr.io/rmyndharis/openwa:0.29.1`, pinned and unmodified.

## Why Deploy OpenWA on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying OpenWA on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
