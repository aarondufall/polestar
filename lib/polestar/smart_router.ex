defmodule Polestar.SmartRouter do
  alias Polestar.{EventRegistry, EventHandler}

  def init(options) do
    options
  end

  def call(conn, _opts) do
    route(conn.method, conn.path_info, conn)
  end

  def route("GET", path_info, conn) do
    # basic route route
    case EventRegistry.lookup(path_info) do
      {:ok, handler, params} -> 
        # TODO, build rest of params
        {:ok, resp } = EventHandler.run(handler, params)
        conn |> Plug.Conn.send_resp(200, resp)
      {:error, reason } ->
        conn
        |> Plug.Conn.send_resp(404, reason)
    end
  end

  def route(_, _, conn) do
    # catch all
    conn |> Plug.Conn.send_resp(404, "oops")
  end
end