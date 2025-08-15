defmodule TodoWeb.TaskLiveReorderTest do
  use TodoWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias Todo.Repo
  alias Todo.Tasks.Task

  import Phoenix.VerifiedRoutes
  @router TodoWeb.Router
  @endpoint TodoWeb.Endpoint

  setup %{conn: conn} do
    task1 = insert_task(%{position: 1000, title: "Task 1"})
    task2 = insert_task(%{position: 2000, title: "Task 2"})
    task3 = insert_task(%{position: 3000, title: "Task 3"})

    {:ok, conn: conn, task1: task1, task2: task2, task3: task3}
  end

  test "reorders a task via LiveView event", %{conn: conn, task1: t1, task2: t2, task3: t3} do
    {:ok, view, _html} = live(conn, ~p"/tasks")

    render_hook(view, "reorder_task", %{
      "moved_id" => t3.id,
      "before_id" => t2.id,
      "next_id" => t1.id
    })

    reordered = Repo.get!(Task, t3.id)

    assert reordered.position > t1.position
    assert reordered.position < t2.position
  end

  defp insert_task(attrs) do
    defaults = %{title: "Sample", position: 0}
    %Task{}
    |> Task.changeset(Map.merge(defaults, attrs))
    |> Repo.insert!()
  end
end
