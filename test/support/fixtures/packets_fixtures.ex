defmodule Aprs.PacketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Aprs.Packets` context.
  """

  @doc """
  Generate a packet.
  """
  def packet_fixture(attrs \\ %{}) do
    {:ok, packet} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Aprs.Packets.create_packet()

    packet
  end
end
