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
      PubSub.subscribe(Aprs.PubSub, "aprs_messages")
    end

    {:ok, assign(socket, :packets, %{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # def handle_info(
  #       %Phoenix.Socket.Broadcast{
  #         event: "packet",
  #         payload: payload,
  #         topic: "aprs_messages"
  #       },
  #       socket
  #     ) do
  #   {:noreply,
  #    socket
  #    |> assign(:packet, payload)}
  # end

  # def handle_info(
  #       %Phoenix.Socket.Broadcast{
  #         event: "packet",
  #         payload: payload,
  #         topic: "aprs_messages"
  #       },
  #       socket
  #     ) do
  #   IO.inspect(payload)
  #     end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          event: "packet",
          payload:
            %{
              base_callsign: base_callsign,
              data_extended: %{latitude: latitude, longitude: longitude}
            } = payload,
          topic: "aprs_messages"
        },
        socket
      ) do
    # IO.inspect(payload)

    {:noreply,
     push_event(socket, "new_marker", %{
       marker: %{
         latitude: latitude,
         longitude: longitude,
         #  symbol_code: payload.data_extended.symbol_code,
         #  symbol_table_id: payload.data_extended.symbol_table_id,
         callsign: base_callsign
       }
     })}
  end

  def handle_info({:new_marker, app}, socket) do
    {:noreply,
     push_event(socket, "new_marker", %{
       marker: %{
         latitude: app.latitude,
         longitude: app.longitude
       }
     })}
  end

  @impl true
  def handle_info(event, socket) do
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Packets")
    |> assign(:packet, nil)
  end
end
