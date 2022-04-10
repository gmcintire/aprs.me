defmodule AprsWeb.PacketLive.Index do
  use AprsWeb, :live_view
  alias Phoenix.PubSub
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    # AprsWeb.Endpoint.subscribe("aprs_packets")
    # PubSub.subscribe(Aprsme.PubSub, "call:" <> params["callsign"])
    if connected?(socket) do
      Logger.debug("Subscribed to PubSub")
      PubSub.subscribe(Aprs.PubSub, "aprs_messages") |> IO.inspect()
    end

    {:ok, assign(socket, :packets, %{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "packet",
          payload: payload,
          topic: "aprs_messages"
        },
        socket
      ) do
    {:noreply,
     socket
     |> assign(:packet, payload)}
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
