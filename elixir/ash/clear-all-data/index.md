# Elixir Ash: clear all data

By Claude.

Here are several ways to clear all migrations in an Elixir Phoenix app with Ash:

## Method 1: Reset Database and Remove Migration Files

```bash
# Drop the database
mix ecto.drop

# Remove all migration files
rm -rf priv/repo/migrations/**
rm -rf priv/resource_snapshots/repo/**

# Create the database
mix ecto.create

# Generate fresh migrations from current Ash resources
mix ash_postgres.generate_migrations --name init 

# If you use Oban, then see section below.

# Run the new migrations
mix ash_postgres.migrate

# Run any seeds
mix run priv/repo/seeds.exs
```

## Oban

Reinitialize:

```sh
mix ecto.gen.migration init_oban
```

Manually edit the migration file:

```sh
edit priv/repo/migrations/*_init_oban.exs
```

Manually add the up function and down function:

```elixir
defmodule MyApp.Repo.Migrations.InitOban do
  use Ecto.Migration

  def up do
    Oban.Migration.up(version: 12)
  end

  def down do
    Oban.Migration.down(version: 1)
  end
end
```

## Method: Rollback All Then Remove

```bash
# Rollback all migrations
mix ecto.rollback --all

# Remove migration files
rm priv/repo/migrations/*.exs

## Method: Using Mix Aliases (Recommended)

Add this to your `mix.exs` for a convenient command:

```elixir
# In mix.exs
defp aliases do
  [
    # ... other aliases
    "ash.reset": [
      "ecto.drop",
      "ecto.create", 
      "cmd rm -f priv/repo/migrations/*.exs",
      "ash_postgres.generate_migrations --name init",
      "ash_postgres.migrate",
      "run priv/repo/seeds.exs"
    ]
  ]
end
```

Then run:
```bash
mix ash.reset
```

## Important Considerations

⚠️ **Warning: These commands will destroy all data!**

1. **Backup First**: Always backup production data before clearing migrations
2. **Development Only**: These approaches are typically only for development environments
3. **Team Coordination**: If working in a team, coordinate migration resets to avoid conflicts
4. **Seeds**: Remember to run seeds after resetting if you have test data

## For Production/Staging

For production environments, you typically want to:

1. Create a new migration to drop and recreate tables
2. Or use a more controlled rollback approach
3. Never delete migration files that have been deployed

```bash
# Production-safe approach
mix ash_postgres.generate_migrations --name recreate_schema
# Then manually edit the migration to drop/recreate as needed
```

## Verify the Reset

After clearing migrations, verify everything works:

```bash
# Check migration status
mix ecto.migrations

# Test your app
mix test

# Start the server
mix phx.server
```

The **Method 1** or **Method 5** (with mix aliases) are typically the most convenient for development work.
