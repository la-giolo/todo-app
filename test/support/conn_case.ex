defmodule TodoWeb.ConnCase do
  @moduledoc """
  This module sets up the test case for tests that require building HTTP connections.

  Such tests rely on `Phoenix.ConnTest` and import other functionality to make
  it easier to build common data structures and query the data layer.

  It also enables the SQL sandbox, so changes done to the database
  are reverted at the end of every test.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import TodoWeb.ConnCase

      alias TodoWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint TodoWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Todo.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Todo.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
