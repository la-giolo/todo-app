defmodule Todo.Tasks.ReorderTest do
  use Todo.DataCase, async: true

  alias Todo.{Repo, Tasks}
  alias Todo.Tasks.Task

  describe "reorder_task/3" do
    test "moves a task between two others using sparse positioning" do
      task1 = create_task(%{position: 1000})
      task2 = create_task(%{position: 2000})
      task3 = create_task(%{position: 3000})

      {:ok, reordered_task} =
        Tasks.reorder_task(task3.id, task2.id, task1.id)

      assert reordered_task.position > task1.position
      assert reordered_task.position < task2.position
    end
  end

  defp create_task(attrs) do
    defaults = %{title: "Sample", position: 0}
    %Task{}
    |> Task.changeset(Map.merge(defaults, attrs))
    |> Repo.insert!()
  end
end
