#!/bin/bash
set -e

echo "🚀 Starting Unykorn 7777 Codespace setup..."

# Install dependencies
echo "📦 Installing npm dependencies..."
npm install

# Copy .env.example if .env doesn't exist
if [ ! -f .env ]; then
  echo "📝 Creating .env from .env.example..."
  cp .env.example .env
fi

# Setup API environment
if [ ! -f apps/api/.env ]; then
  echo "📝 Creating apps/api/.env..."
  cat > apps/api/.env <<EOF
# API Environment Variables
NODE_ENV=development
PORT=4000

# Database (matches docker-compose)
DATABASE_URL=postgresql://unykorn:unykorn@localhost:5432/orgdb?schema=public

# XRPL Network (devnet | testnet | mainnet)
XRPL_NETWORK=testnet

# Xumm API Keys (set these from your Xumm Console or Codespaces Secrets)
XUMM_API_KEY=\${XAMANAPI:-}
XUMM_API_SECRET=\${XAMANKEY:-}

# CORS (leave blank in dev to allow all)
CORS_ORIGINS=

# JWT Secret
JWT_SECRET=dev_secret_change_in_production
EOF
fi

# Start PostgreSQL via docker compose
echo "🐘 Starting PostgreSQL container..."
docker compose up -d db

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until docker compose exec -T db pg_isready -U unykorn; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done
echo "✅ PostgreSQL is ready!"

# Generate Prisma client
echo "🔧 Generating Prisma client..."
npm run -w @unykorn/api prisma:generate

# Run Prisma migrations
echo "🔧 Running Prisma migrations..."
npm run -w @unykorn/api prisma:migrate || echo "⚠️  Migration skipped (may already exist)"

# Optional: Seed the database
echo "🌱 Seeding database (optional)..."
npm run -w @unykorn/api seed || echo "⚠️  Seed skipped"

echo ""
echo "✅ Codespace setup complete!"
echo ""
echo "🎯 Next steps:"
echo "  1. Set Codespaces Secrets (if not already set):"
echo "     - XAMANAPI (Xumm API Key)"
echo "     - XAMANKEY (Xumm API Secret)"
echo "     - CLOUDFLARE_API_TOKEN or CF_API_TOKEN (optional, for DNS automation)"
echo ""
echo "  2. Start the development servers:"
echo "     npm run dev"
echo ""
echo "  3. Or start them individually:"
echo "     npm run dev:web   # Web app on port 3000"
echo "     npm run dev:api   # API server on port 4000"
echo "     npm run dev:admin # Admin app on port 3001"
echo ""
echo "  4. Open the Jupyter notebook for guided setup:"
echo "     Unykorn-Ignite.ipynb"
echo ""
echo "🔗 Useful endpoints:"
echo "  - Web: http://localhost:3000"
echo "  - Admin: http://localhost:3001"
echo "  - API Health: http://localhost:4000/health"
echo "  - API Xumm: http://localhost:4000/xumm/ping"
echo ""
