defmodule ExDebugToolbar.BreakpointChannelTest do
  use ExDebugToolbar.ChannelCase, async: true

  alias ExDebugToolbar.{BreakpointChannel, Toolbar}
  require Toolbar

  test "joining and interacting with breakpoint" do
    Toolbar.pry
    breakpoint = Toolbar.get_all_breakpoints() |> hd
    topic = "breakpoint:" <> breakpoint.id

    # initial output
    {:ok, _, socket} = socket() |> subscribe_and_join(BreakpointChannel, topic, %{})

    # echo input
    push socket, "input", %{"input" => "€"}

    Toolbar.delete_breakpoint breakpoint.id
  end

  test "it returns error on join if breakpoint doesn't exist" do
    topic = "breakpoint:invalid_id"
    assert {:error, %{reason: :not_found}} = socket() |> subscribe_and_join(BreakpointChannel, topic, %{})
  end
end
