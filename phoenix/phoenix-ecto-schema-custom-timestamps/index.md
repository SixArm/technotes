# Phoenix Ecto custom timestamps

## Ash Resource

We prefer to edit domain resource files such as [`lib/my_app/my_domain/item.ex`](lib/my_app/my_domain/item.ex) to move the timestamps to the start of the attributes, and to name them the way we prefer.

From this:

```elixir
  attributes do
    uuid_primary_key :id
    …
    timestamps()
```

Into this:

```elixir
  attributes do
    uuid_primary_key :id
    create_timestamp :created_at
    update_timestamp :updated_at
```

## Schema

We prefer to create an app schema because we prefer to customize timestamps.

We prefer `:utc_datetime_usec` because we prefer explicit UTC and we prefer microsecond precision. This improves how Postgres behaves with other clients to the database.

```sh
mix phx.gen.schema MyApp.Schema
```

Edit the new file [`lib/my_app/schema/my_app_schema.ex`](lib/my_app/schema/my_app_schema.ex).

```elixir
defmodule MyApp.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts 
            type: :utc_datetime_usec,
            inserted_at: :created_at,
            updated_at: :updated_at
        )
    end
  end
end
