defmodule Cell.Mail do

  #creates a separate process that awaits to receive a message to send out an email
  def init() do
    spawn(Cell.Mail, :prepare, [])
  end

  #auto called when the process is being created to wait for a message
  #after this process receives a send mail request message it will die
  #initentionally there is no recursive call to prepare/1 to keep it in an active loop
  def prepare() do
    receive do
      {:req_send_email, todo} -> send_email(todo)
      _ -> :un_known_message
    end
  end

  defp send_email(todo) do
    {:ok, "Email has been sent #{todo}"}
  end
end
