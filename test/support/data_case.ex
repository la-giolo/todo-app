defmodule Todo.DataCase do
  @moduledoc """
  Sets up the test environment for database-related tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Todo.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Todo.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Todo.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Todo.Repo, {:shared, self()})
    end

    :ok
  end
end
