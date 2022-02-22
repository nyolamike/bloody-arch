# TagAndFollow


**Tag And Follow** 🏷  is a platform that continously accumulates posted internet resources links against tags that a user has subscribed to by following those tags. 

The idea is to send notifications 🔔  whenever a users tag following recieves a new posted resource. Also to accumulate results over a week and send new results via email 📧 , or to send these results to the chat platform as a DM 💬 , or to send over the results via our web or mobile app. 📱 

## Architectural Design ruler 📐 

The history of this project stem from these articles:

The system is designed using an **Actor Model Framework** where by, in this case the actors are called **Cells**. Cells are generally implementing the **GenServer behaviour**, apart from the mailing, notifications and sms cells. There are three types of cells: 

- The mail, sms, notification cells are collectively known as the **Short Lived Cells**, they are brief short lived processes, usually when spawn will await to receive a single request message, they process this message asynchronouly and are destroyed immediately. As of the current version we are not tracing for any responses or errors that these cells may generate.


## Running Tests 🧪 

Each source code file in the 📂  */lib* directory has a corresponding test file in the 📂  */test* directory.

Inside the test files, module test namespaces are named like this "module_name.Test" to be consistent with the module being tested.

To run all tests, execute the following command at the root directory of the project

```elixir
mix test
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tag_and_follow` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tag_and_follow, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tag_and_follow>.

