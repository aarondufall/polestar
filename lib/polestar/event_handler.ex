defmodule Polestar.EventHandler do
  require Logger
  
  def run(task,params) do
    Logger.debug "Running Job: #{task}"
    {:ok, "Running: #{inspect task} params: #{inspect params}"}
  end
end