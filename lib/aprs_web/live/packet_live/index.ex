defmodule AprsWeb.PacketLive.Index do
  use AprsWeb, :live_view
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    AprsWeb.Endpoint.subscribe("aprs_packets")
    # PubSub.subscribe(Aprsme.PubSub, "call:" <> params["callsign"])
    # PubSub.subscribe(Aprs.PubSub, "aprs_packets")

    {:ok, assign(socket, :packets, %{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(event, socket) do
    IO.inspect(event)
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Packets")
    |> assign(:packet, nil)
  end
end
