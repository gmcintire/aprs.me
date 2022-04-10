defmodule Aprs.PacketsTest do
  use Aprs.DataCase

  alias Aprs.Packets

  describe "packets" do
    alias Aprs.Packets.Packet

    import Aprs.PacketsFixtures

    @invalid_attrs %{name: nil}

    test "list_packets/0 returns all packets" do
      packet = packet_fixture()
      assert Packets.list_packets() == [packet]
    end

    test "get_packet!/1 returns the packet with given id" do
      packet = packet_fixture()
      assert Packets.get_packet!(packet.id) == packet
    end

    test "create_packet/1 with valid data creates a packet" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Packet{} = packet} = Packets.create_packet(valid_attrs)
      assert packet.name == "some name"
    end

    test "create_packet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Packets.create_packet(@invalid_attrs)
    end

    test "update_packet/2 with valid data updates the packet" do
      packet = packet_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Packet{} = packet} = Packets.update_packet(packet, update_attrs)
      assert packet.name == "some updated name"
    end

    test "update_packet/2 with invalid data returns error changeset" do
      packet = packet_fixture()
      assert {:error, %Ecto.Changeset{}} = Packets.update_packet(packet, @invalid_attrs)
      assert packet == Packets.get_packet!(packet.id)
    end

    test "delete_packet/1 deletes the packet" do
      packet = packet_fixture()
      assert {:ok, %Packet{}} = Packets.delete_packet(packet)
      assert_raise Ecto.NoResultsError, fn -> Packets.get_packet!(packet.id) end
    end

    test "change_packet/1 returns a packet changeset" do
      packet = packet_fixture()
      assert %Ecto.Changeset{} = Packets.change_packet(packet)
    end
  end
end
