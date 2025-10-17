# GitHub Codespaces Configuration

This directory contains the configuration for GitHub Codespaces, enabling you to develop the Unykorn 7777 platform in a cloud-based development environment.

## What's Included

The Codespace configuration automatically sets up:

- **Node.js 20** runtime environment
- **Docker-in-Docker** for running PostgreSQL and other containers
- **PostgreSQL database** (via docker-compose)
- **Git** for version control
- **Pre-installed dependencies** (npm packages)
- **Prisma** ORM with migrations applied
- **VS Code extensions** for JavaScript/TypeScript, Prisma, Docker, and more

## Features

### Automatic Setup

When you open this repository in a Codespace, the following happens automatically:

1. ✅ Node.js environment is configured
2. ✅ All npm dependencies are installed
3. ✅ Environment files (`.env`) are created from templates
4. ✅ PostgreSQL container is started
5. ✅ Prisma client is generated
6. ✅ Database migrations are applied
7. ✅ Sample data is optionally seeded

### Port Forwarding

The following ports are automatically forwarded and labeled:

- **3000** - Web App (Next.js frontend)
- **3001** - Admin App
- **4000** - API Server (Express backend)
- **5432** - PostgreSQL Database

### VS Code Extensions

Pre-installed extensions include:

- ESLint & Prettier for code formatting
- Prisma for database schema editing
- Docker for container management
- Jupyter for running `.ipynb` notebooks
- GitHub Copilot for AI-assisted coding

## Getting Started

### 1. Create a Codespace

**Option A: From GitHub UI**
1. Go to the repository on GitHub
2. Click the green "Code" button
3. Select the "Codespaces" tab
4. Click "Create codespace on main" (or your branch)

**Option B: From GitHub CLI**
```bash
gh codespace create --repo kevanbtc/UnyKorn7777
```

### 2. Configure Secrets (Recommended)

For full functionality, especially XRPL/Xumm integration, set up Codespaces Secrets:

1. Go to GitHub → Settings → Codespaces → Secrets
2. Add the following secrets:
   - `XAMANAPI` - Your Xumm API Key
   - `XAMANKEY` - Your Xumm API Secret
   - `CLOUDFLARE_API_TOKEN` (optional) - For DNS automation
   - `CF_ZONE_ID` (optional) - Your Cloudflare Zone ID

3. Ensure secrets are available to this repository (not "0 repositories")
4. Restart the Codespace after adding secrets

### 3. Start Development Servers

Once the Codespace is ready:

```bash
# Start all services (web, api, admin)
npm run dev

# Or start individually:
npm run dev:web   # Web app (port 3000)
npm run dev:api   # API server (port 4000)
npm run dev:admin # Admin app (port 3001)
```

### 4. Verify Installation

Check that everything is working:

```bash
# Check API health
curl http://localhost:4000/health

# Check Xumm integration (requires secrets)
curl http://localhost:4000/xumm/ping

# Check public config
curl http://localhost:4000/public/config
```

## Using the Unykorn Ignite Notebook

For a guided setup experience, use the included Jupyter notebook:

1. Open `Unykorn-Ignite.ipynb` in VS Code
2. Run cells from top to bottom
3. The notebook will:
   - Bridge Codespaces secrets to environment variables
   - Restart and verify the API
   - Configure Cloudflare DNS (if secrets are set)
   - Validate all systems

## Troubleshooting

### Ports Already in Use

If you get `EADDRINUSE` errors:

```bash
npm run dev:reset  # Kills processes on ports 3000, 3001, 4000
```

### Database Connection Issues

Check if PostgreSQL is running:

```bash
docker compose ps
docker compose logs db
```

Restart the database:

```bash
docker compose restart db
```

### Missing Xumm Keys

If `/xumm/ping` returns errors about missing keys:

1. Check that Codespaces Secrets are set (see step 2 above)
2. Restart the Codespace to inject secrets
3. Or manually export them in your terminal:
   ```bash
   export XUMM_API_KEY="your-key"
   export XUMM_API_SECRET="your-secret"
   ```

### Rebuilding the Codespace

If something goes wrong, you can rebuild:

1. Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
2. Type "Codespaces: Rebuild Container"
3. Select it to rebuild from scratch

## Architecture

```
Unykorn 7777 Monorepo
├── apps/
│   ├── web/        # Next.js frontend (port 3000)
│   ├── admin/      # Admin dashboard (port 3001)
│   └── api/        # Express API (port 4000)
├── packages/
│   ├── shared/     # Shared utilities
│   ├── web3/       # XRPL integration
│   └── ai-core/    # AI agent modules
└── .devcontainer/  # This directory
    ├── devcontainer.json  # Codespace configuration
    ├── setup.sh           # Post-creation setup script
    └── README.md          # This file
```

## Customization

### Modifying the Setup

Edit `.devcontainer/setup.sh` to customize the post-creation setup process.

### Adding VS Code Extensions

Edit the `customizations.vscode.extensions` array in `devcontainer.json`.

### Environment Variables

Default environment variables are set in:
- `.env` (root level)
- `apps/api/.env` (API-specific)

You can modify these or use Codespaces Secrets for sensitive values.

## Resources

- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)
- [Dev Containers Specification](https://containers.dev/)
- [Unykorn 7777 Main README](../README.md)
- [Operations Runbook](../docs/OPERATIONS.md)

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review logs: `docker compose logs` or check the terminal output
3. Consult the main `README.md` for project-specific guidance
4. Open an issue on GitHub with details about your problem
