defmodule HelloWeb.PageLive do
  use Phoenix.LiveView
  alias HelloWeb.State

  def mount(_session, socket) do
    {:ok, assign(socket, state: %State{})}
  end

  def render(assigns) do
    HelloWeb.PageView.render("index.html", assigns)
  end
end
