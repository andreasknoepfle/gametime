defmodule Turn do
  use Task

  def start(callback) do
    {:ok, pid} = Task.start_link(fn -> advance_after_timeout(callback) end)
    pid
  end

  def done(pid) do
    send(pid, :done)
  end

  def advance_after_timeout(callback) do
    receive do
      :done -> callback.()
    after
      500 ->
        callback.()
    end
  end
end
