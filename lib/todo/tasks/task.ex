defmodule Todo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :is_completed, :boolean, default: false
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :is_completed, :position])
    |> validate_required([:title, :is_completed])
  end
end
