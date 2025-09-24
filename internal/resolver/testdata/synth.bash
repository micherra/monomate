# --- create synthetic monorepos for resolver & end-to-end demos ---
set -euo pipefail

BASE="synth"
rm -rf "$BASE"
mkdir -p "$BASE"

###############################################################################
# 1) tinyverse-like monorepo: apps + packages + tooling (workspaces: array)
###############################################################################
TINY="$BASE/tinyverse-like"
mkdir -p "$TINY/{apps,packages,tooling}"
cat > "$TINY/package.json" <<'JSON'
{
  "private": true,
  "name": "tinyverse-root",
  "packageManager": "bun@1.1.29",
  "workspaces": ["apps/*", "packages/*", "tooling/*"],
  "scripts": {
    "build": "echo build all",
    "test": "echo test all"
  }
}
JSON

# apps
mkdir -p "$TINY/apps/studio" "$TINY/apps/api"
cat > "$TINY/apps/studio/package.json" <<'JSON'
{
  "name": "@tinyverse/studio",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "bun run vite",
    "build": "bun run vite build",
    "test": "bun test"
  },
  "dependencies": {
    "@tinyverse/core": "workspace:*",
    "@tinyverse/ui": "workspace:*"
  }
}
JSON

cat > "$TINY/apps/api/package.json" <<'JSON'
{
  "name": "@tinyverse/api",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "bun run node src/server.js",
    "build": "echo building api",
    "test": "bun test"
  },
  "dependencies": {
    "@tinyverse/core": "workspace:*",
    "@tinyverse/agent": "workspace:*"
  }
}
JSON

# packages (libraries)
mkdir -p "$TINY/packages/core" "$TINY/packages/agent" "$TINY/packages/ui"
cat > "$TINY/packages/core/package.json" <<'JSON'
{
  "name": "@tinyverse/core",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build core",
    "test": "bun test"
  }
}
JSON

cat > "$TINY/packages/agent/package.json" <<'JSON'
{
  "name": "@tinyverse/agent",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build agent",
    "test": "bun test"
  },
  "dependencies": {
    "@tinyverse/core": "workspace:*"
  }
}
JSON

cat > "$TINY/packages/ui/package.json" <<'JSON'
{
  "name": "@tinyverse/ui",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build ui",
    "test": "bun test"
  }
}
JSON

# tooling (lint config as a package)
mkdir -p "$TINY/tooling/eslint-config"
cat > "$TINY/tooling/eslint-config/package.json" <<'JSON'
{
  "name": "@tinyverse/eslint-config",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build tooling",
    "test": "echo tooling tests"
  }
}
JSON

###############################################################################
# 2) shop platform monorepo: object workspaces + nested globs (workspaces: object)
###############################################################################
SHOP="$BASE/shop-platform"
mkdir -p "$SHOP/services" "$SHOP/packages" "$SHOP/apps" "$SHOP/tools"
cat > "$SHOP/package.json" <<'JSON'
{
  "private": true,
  "name": "shop-platform-root",
  "packageManager": "bun@1.1.29",
  "workspaces": {
    "packages": ["apps/*", "packages/*", "services/*", "tools/*"]
  },
  "scripts": {
    "build": "echo build all",
    "test": "echo test all"
  }
}
JSON

# apps
mkdir -p "$SHOP/apps/web" "$SHOP/apps/admin"
cat > "$SHOP/apps/web/package.json" <<'JSON'
{
  "name": "@shop/web",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "bun run next dev",
    "build": "bun run next build",
    "start": "bun run next start",
    "test": "bun test"
  },
  "dependencies": {
    "@shop/ui": "workspace:*",
    "@shop/api-client": "workspace:*"
  }
}
JSON

cat > "$SHOP/apps/admin/package.json" <<'JSON'
{
  "name": "@shop/admin",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "echo admin dev",
    "build": "echo admin build",
    "test": "bun test"
  },
  "dependencies": {
    "@shop/ui": "workspace:*"
  }
}
JSON

# services
mkdir -p "$SHOP/services/catalog" "$SHOP/services/checkout"
cat > "$SHOP/services/catalog/package.json" <<'JSON'
{
  "name": "@shop/svc-catalog",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "bun run node src/index.js",
    "build": "echo build catalog",
    "test": "bun test"
  },
  "dependencies": {
    "@shop/db": "workspace:*",
    "@shop/logger": "workspace:*"
  }
}
JSON

cat > "$SHOP/services/checkout/package.json" <<'JSON'
{
  "name": "@shop/svc-checkout",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "bun run node src/index.js",
    "build": "echo build checkout",
    "test": "bun test"
  },
  "dependencies": {
    "@shop/db": "workspace:*",
    "@shop/logger": "workspace:*",
    "@shop/payments": "workspace:*"
  }
}
JSON

# packages (shared libs)
mkdir -p "$SHOP/packages/ui" "$SHOP/packages/api-client" "$SHOP/packages/db" "$SHOP/packages/logger" "$SHOP/packages/payments"
cat > "$SHOP/packages/ui/package.json" <<'JSON'
{
  "name": "@shop/ui",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build ui",
    "test": "bun test"
  }
}
JSON

cat > "$SHOP/packages/api-client/package.json" <<'JSON'
{
  "name": "@shop/api-client",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build api-client",
    "test": "bun test"
  },
  "dependencies": {
    "@shop/logger": "workspace:*"
  }
}
JSON

cat > "$SHOP/packages/db/package.json" <<'JSON'
{
  "name": "@shop/db",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build db",
    "migrate": "echo run migrations",
    "test": "bun test"
  }
}
JSON

cat > "$SHOP/packages/logger/package.json" <<'JSON'
{
  "name": "@shop/logger",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build logger",
    "test": "bun test"
  }
}
JSON

cat > "$SHOP/packages/payments/package.json" <<'JSON'
{
  "name": "@shop/payments",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "build": "echo build payments",
    "test": "bun test"
  }
}
JSON

# tools (CLIs/utilities as workspaces)
mkdir -p "$SHOP/tools/cli"
cat > "$SHOP/tools/cli/package.json" <<'JSON'
{
  "name": "@shop/cli",
  "version": "0.1.0",
  "type": "module",
  "bin": {
    "shop": "bin/shop.js"
  },
  "scripts": {
    "build": "echo build cli",
    "test": "echo cli tests"
  }
}
JSON

# handy readme for humans
cat > "$BASE/README.md" <<'MD'
# Synthetic monorepos

- **tinyverse-like/** — classic apps+packages+tooling layout; `workspaces` as **array**.
- **shop-platform/** — apps/services/packages/tools; `workspaces` as **object** with `packages: []`.

All packages include `name` and `scripts` to satisfy the resolver. Bun is declared via `packageManager`.
MD

echo "✅ Created realistic synthetic monorepos under $BASE"
