defmodule Polestar.Endpoint do
  use GenServer


  def start_link do
    GenServer.start_link(__MODULE__,[])
  end

  def init([]) do
    {:ok, http_server} = Plug.Adapters.Cowboy.http Polestar.AppRouter, []
    {:ok, %{server: http_server}}
  end

end