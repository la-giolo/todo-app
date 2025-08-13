defmodule Todo.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo

  alias Todo.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Task
    |> order_by(:position)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    max_position = Repo.one(from t in Task, select: max(t.position)) || 0

    next_position = max_position + 1000

    attrs = Map.put(attrs, "position", next_position)

    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def reorder_task(moved_id, before_id, next_id) do
    before_pos =
      if before_id,
        do: Repo.get!(Task, before_id).position,
        else: nil

    next_pos =
      if next_id,
        do: Repo.get!(Task, next_id).position,
        else: nil

    new_pos = calculate_new_pos(before_pos, next_pos)

    Task
    |> Repo.get!(moved_id)
    |> Ecto.Changeset.change(position: new_pos)
    |> Repo.update!()
  end

  defp calculate_new_pos(nil, nil) do
    # only item in the list
    1000
  end

  defp calculate_new_pos(nil, next) do
    # moved to very top
    div(next, 2)
  end

  defp calculate_new_pos(before, nil) do
    # moved to very bottom
    before + 1000
  end

  defp calculate_new_pos(before, next) do
    # placed between two tasks
    div(before + next, 2)
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
