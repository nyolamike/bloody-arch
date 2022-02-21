defmodule Cell.Tag.Util.Test do
  use ExUnit.Case

  test "Tag cell follows a user by adding the users uuid to the list of followers" do
    sender = spawn(fn -> IO.puts("sender") end)
    receiver = self()

    initial_state = %{
      followers: []
    }

    user_uuid = "4657585"

    modified_state =
      Cell.Tag.Util.follow_tag(
        receiver,
        %{
          name: :req_follow_tag,
          sender: sender,
          receiver: receiver,
          payload: %{
            uuid: user_uuid
          },
          thread: []
        },
        initial_state
      )

    assert modified_state.followers == [user_uuid]
  end
end
