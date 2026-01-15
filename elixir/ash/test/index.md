# Ash testing

<https://elixirforum.com/t/testing-ash-share-your-design-and-best-practices/63238>

## 1. Resource generation (fixture)

Within a classical Phoenix application, fixtures are written as follow:

```elixir
defmodule MyApp.SupportFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyApp.Support` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(ticket_valid_attrs())
      |> MyApp.Support.create_ticket()

    ticket
  end

  def ticket_valid_attrs() do
    %{subject: "some subject"}
  end
end
```elixir

Then you can test like this:

```elixir
defmodule MyApp.SupportTest do
  use MyApp.DataCase

  alias MyApp.Support

  import MyApp.SupportFixtures

  @tag :phoenix
  describe "tickets" do
    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Support.list_tickets() == [ticket]
    end
  end
end
```elixir

Now with Ash Framework, generating the fixture can look like:

```elixir
defmodule MyApp.SupportFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyApp.Support` context.
  """

  alias MyApp.Support
  alias MyApp.Support.Ticket

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    final_attrs = attrs |> Enum.into(ticket_valid_attrs())

      Ash.Changeset.for_create(Ticket, :create, final_attrs)
      |> Support.create!()
  end

  def ticket_valid_attrs() do
    %{subject: "some subject"}
  end
end
```elixir

And the test can be:

```elixir
defmodule MyApp.SupportTest do
  use MyApp.DataCase

  alias MyApp.Support

  import MyApp.SupportFixtures

  @tag :ash
  describe "tickets" do
    alias MyApp.Support.Ticket

    test "read returns all tickets" do
      ticket = ticket_fixture()

      assert Ash.Query.for_read(Ticket, :read) |> Support.read!() ==
               [ticket]
    end
  end
end
```elixir

But this test will fail, with the following error message:

```out
Assertion with == failed
     code:  assert Ash.Query.for_read(Ticket, :read) |> Support.read!() == [ticket]
     left:  [
              %MyApp.Support.Ticket{
                __lateral_join_source__: nil,
                __meta__: #Ecto.Schema.Metadata<:loaded, "tickets">,
                __metadata__: %{
                  selected: [:id, :subject, :status, :representative_id]
                },
                __order__: nil,
                aggregates: %{},
                calculations: %{},
                id: "9ec80178-b60d-48f2-b86e-892300d6ba90",
                representative: #Ash.NotLoaded<:relationship, field: :representative>,
                representative_id: nil,
                status: :open,
                subject: "some subject"
              }
            ]
     right: [
              %MyApp.Support.Ticket{
                __lateral_join_source__: nil,
                __meta__: #Ecto.Schema.Metadata<:loaded, "tickets">,
                __metadata__: %{},
                __order__: nil,
                aggregates: %{},
                calculations: %{},
                id: "9ec80178-b60d-48f2-b86e-892300d6ba90",
                representative: #Ash.NotLoaded<:relationship, field: :representative>,
                representative_id: nil,
                status: :open,
                subject: "some subject"
              }
            ]
```

The basic solution I found to fix it is querying the ticket from the database after it’s creation inside the fixture:

```elixir
defmodule MyApp.SupportFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyApp.Support` context.
  """

  alias MyApp.Support
  alias MyApp.Support.Ticket

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    final_attrs = attrs |> Enum.into(ticket_valid_attrs())

    ticket =
      Ash.Changeset.for_create(Ticket, :create, final_attrs)
      |> Support.create!()

    Ash.Query.for_read(Ticket, :by_id, %{id: ticket.id})
    |> Support.read_one!()
  end

  def ticket_valid_attrs() do
    %{subject: "some subject"}
  end
end
```elixir

But I find this solution is redundant. I wonder if anyone has a better solution for such a case. How would you handle the variations of the metadata field?

## 2. JSON schema assertion

Within a classical Phoenix App, each schema has it’s own controller to handle requests at the server level, and JSON module to render the data.

Controller:

```elixir
defmodule MyAppWeb.Api.Support.TicketController do
  use MyAppWeb, :controller

  alias MyApp.Support

  action_fallback MyAppWeb.Api.FallbackController

  def index(conn, _params) do
    tickets = Support.list_tickets()
    render(conn, :index, tickets: tickets)
  end
end
```

JSON view:

```elixir
defmodule MyAppWeb.Api.Support.TicketJSON do
  alias MyApp.Support.Ticket

  @doc """
  Renders a list of tickets.
  """
  def index(%{tickets: tickets}) do
    %{data: for(ticket <- tickets, do: data(ticket))}
  end

  def data(%Ticket{} = ticket) do
    %{
      id: ticket.id,
      subject: ticket.subject,
      status: ticket.status,
    }
  end
end
```

Then you can test it like that:

```elixir
defmodule MyAppWeb.Api.Support.TicketControllerTest do
  use MyAppWeb.ConnCase

  import MyApp.SupportFixtures

  alias MyAppWeb.Api.Support.TicketJSON

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup [:create_and_set_api_key]

  describe "index" do
    setup [:create_ticket]

    @tag :phoenix
    test "lists all tickets", %{conn: conn, ticket: ticket} do
      conn = get(conn, ~p"/api/v1/support/tickets")

      assert json_response(conn, 200)["data"] == [
               ticket |> to_normalised_json()
             ]
    end

  defp create_ticket(_) do
    ticket = ticket_fixture()

    %{ticket: ticket}
  end

  defp to_normalised_json(data) do
    data
    |> TicketJSON.data()
    |> normalise_json()
  end
end
```

With normalise_json/1 defined in MyAppWeb.ConnCase module:

```elixir
defmodule MyAppWeb.ConnCase do
  @moduledoc """ ... """
  use ExUnit.CaseTemplate

  import Plug.Conn

[...]
  @doc """
  Format data to be normalised JSON and pass asserts in tests.
  """
  def normalise_json(data) do
    data
    |> Jason.encode!()
    |> Jason.decode!()
  end
[...]
end
```

It makes the assertion easy with any kind of schema since we pass the created ticket to the same function used by the controller to render the data.

With AshJsonApi, rendered resources are autogenerated from the resource description, so how would you make the assertion easy with data coming from a newly created ticket for instance? It would be nice to be able to use the same function that is used by AshJsonApi.Controllers.Get to generate the JsonApi schema for instance, but I’m currently not used to how it works.

```elixir
defmodule MyAppWeb.AshControllerTest do
  use MyAppWeb.ConnCase

  import MyApp.SupportFixtures

  defp create_ticket(_) do
    ticket = ticket_fixture()

    %{ticket: ticket}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/vnd.api+json")}
  end

  setup [:create_and_set_api_key]

  describe "index" do
    setup [:create_ticket]

    @tag :ash
    test "lists all tickets", %{conn: conn, ticket: ticket} do
      conn = get(conn, ~p"/ash/tickets")

      assert json_response(conn, 200)["data"] == "data"
    end
  end
end
```

This code renders an error message:

```out
Assertion with == failed
     code:  assert json_response(conn, 200)["data"] == "data"
     left:  [%{"attributes" => %{"representative_id" => nil, "status" => "open", "subject" => "some subject"}, "id" => "4ed2d671-2961-4ffc-9435-40413862ecf4", "links" => %{}, "meta" => %{}, "relationships" => %{"representative" => %{"links" => %{}, "meta" => %{}}}, "type" => "ticket"}]
     right: "data"
```

I could copy/paste the left side and re-arrange it to populate values with variables such as "id" => ticket.id, but I’m looking for something that I don’t need to modify in tests each time I will bring modifications to the JSON rendered schema.

Design

1. Design Ash controllers tests

As we have seen in my previous examples, a common design for API controllers in Phoenix applications is to have:

1 Controller file per schema

1 JSON file per schema

With Ash, and more specifically AshJsonApi, we have:

1 generic (dependency level) Controller file per action

1 generic (dependency level) JSON generator → for all resources? (to clarify, my comprehension is not perfect on it for now)

So I wonder what would be the best strategy for tests:

create a ControllerTest file for each resource (equivalent to ControllerTest file for each schema which I currently have on Phoenix)

OR

create a ControllerTest file for each action

While writing it, I think the first option is the best, as I find it logic to regroup tests by resources (it creates a better overview of what you can / cannot do with your resource’s API, just as you have an overview of each resource in their respective Ash.Resource file).

Maybe some of you came with a third approach that I haven’t thought of, feedbacks are more than welcome to share the best practices!

I put again my questions here:

- How would you handle the variations of the metadata field?
- How would you normalize the assigns with JSON renders in controllers tests?
- How do you organize your controller tests with Ash (AshJsonApi or AshGraphQL even if I’m not sure to use the second in the short term)

## Zach replies

Here are some things, some in response to your questions, some things worth knowing while testing, in no particular order.

### Actions vs Seeds

While I often suggest using your resource actions to create data when you can, you may also need to reach for seeds. This can often make large differences in the speed of your tests. Ash has tools for this in Ash.Seed. For example:

```elixir
Ash.Seed.seed!(%Ticket{})` 
```

Additionally, @jimsynz has created a layer on top of Ash.Seed with great ergonomics that many folks enjoy called Smokestack.

### Generators and StreamData

Ash has utilities built in that work with StreamData to allow for generating valid values (and in the future invalid values). This can be used with Ash.Generator, for example:

```elixir
Ash.Generator.many_changesets(%Ticket{}, :update, 10)
```

And it can also be used for property testing:

```elixir
check all(input <- Ash.Generator.action_input(Resource, :create) do
  ...
end
```

### Handling metadata

You can solve this one of two ways:

use pattern matching or more specific assertions, not ==. This doesn’t work everywhere, but can be useful.

For example:

```elixir
assert [%{id: ^ticket_id}] = 
assert [result] = Ash.Query.for_read(Ticket, :read) |> Support.read!()
assert result.id == ticket.id
Use Ash.Test.strip_metadata/
```

There is a tool for this, called `Ash.Test.strip_metadata/1`. This can let you make your assertions, i.e

```elixir
assert strip_metadata(Ash.Query.for_read(Ticket, :read) |> Support.read!()) == strip_metadata([ticket])
```

You can call it on result tuples or lists, and it will strip the metadata of any contained records.

### Testing APIs

Honestly, it isn’t generally possible for Ash to produce something that doesn’t match the schema it defines. I personally would be testing specific behavioral things. (and I’d use AshJsonApi.Test to do it). For example:

```elixir
import AshJsonApi.Test
  
@tag :phoenix
test "lists all tickets", %{conn: conn, ticket: ticket} do
  MyApp.Support
  # get and assert on status
    |> get("/api/v1/support/tickets", status: 200) 
    |> assert_data_equals([%{...}, %{...}])
end
```

I think there are some potentially missing assertions for AshJsonApi that would be really nice, like assert_data_matches where you provide a pattern, and so on. But you could copy the pattern of our assertions (and maybe PR some to ash_json_api, as they assert and return the original conn. (Actually, I found a few assertions that weren’t doing this while checking this out, and have pushed dup a fix for them :slight_smile: )

But ultimately, the point is that with Ash you don’t really have to test “can it turn an instance of my resource into a valid response”, you need to test the behavior of the action. i.e that all existing tickets are contained in the response, or whatever other action-specific things you have going.

### Unit Testing in Ash is different

For example, you can unit test a calculation directly, i.e

```elixir
calculate :full_name, :string, expr(first_name <> " " <> last_name)
assert Ash.calculate!(User, :full_name, refs: [first_name: "Zach", last_name: "Daniel"]) == "Zach Daniel"
```

When testing this calculation, I would likely do it at the resource level, not the api level. This same thing is true for a lot of cases for me. I would likely have most of my tests at the action/Resource level.

