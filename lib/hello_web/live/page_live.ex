defmodule HelloWeb.PageLive do
  use Phoenix.LiveView
  alias HelloWeb.State

  def mount(_session, socket) do
    {:ok, assign(socket, state: %State{})}
  end

  def render(assigns) do
    HelloWeb.PageView.render("index.html", assigns)
  end

  def handle_event("place", index, %{assigns: assigns} = socket) do
    new_state =
      String.to_integer(index)
      |> State.click(%{assigns.state | show_character: nil})

    {:noreply, assign(socket, state: new_state)}
    # {:noreply, socket}
  end

  def handle_event("change", index, %{assigns: assigns} = socket) do
    new_state = State.changed_edit_case_color(assigns.state)
    {:noreply, assign(socket, state: new_state)}
  end

  def handle_event("enter", index, %{assigns: assigns} = socket) do
    new_state = State.enter(assigns.state)
    {:noreply, assign(socket, state: new_state)}
  end
end
