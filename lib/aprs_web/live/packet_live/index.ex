defmodule AprsWeb.PacketLive.Index do
  use AprsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # MyAppWeb.Endpoint.subscribe("aprs_packets")

    {:ok, assign(socket, :packets, list_packets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Packets")
    |> assign(:packet, nil)
  end

  defp list_packets do
  end
end
