defmodule Polestar.AppRouter do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch


  forward "/", to: Polestar.SmartRouter
end