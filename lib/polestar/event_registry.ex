defmodule Polestar.EventRegistry do
  use GenServer
  require Logger

  @test_routes ["users/:id/profile","/users/:id/settings","users/:id/profile/edit","users/:id","course/:course_id/module/:id"]
  # Client API
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    state = Enum.map(@test_routes, &route_info/1)
    Logger.debug "INIT REGISTRY: #{inspect state}"
    {:ok, state}
  end

  def lookup(path_info) do
    GenServer.call(__MODULE__, {:lookup, path_info})
  end

  def add_route(url, event_json) do
    GenServer.call(__MODULE__, {:add_route, url, event_json})
  end

  # Callbacks
  def handle_call({:lookup, path_info},_from,routes) do
    Logger.info "Looking up path info #{inspect path_info}"
    {:reply,match(routes,path_info),routes}
  end

  def handle_call({:add_route, url, event_json}, _from, routes) do
    Logger.info "Adding #{url} to route store"
    routes = [route_info(url) | routes] 
    {:reply, routes, routes}
  end


  # Helpers
  def match(routes,path_info) do
    routes
    |> filter_by_length(path_info)
    |> match_values(path_info)
  end

  def filter_by_length(routes,path_info) do
    #TODO routes can be converted to a list on creation
    Enum.map(routes, &route_info/1) 
    |> Enum.filter(fn(route) ->
      Enum.count(path_info) == Enum.count(route)
    end)
  end

  def route_info(route) do
    route
    |> String.split("/")
    |> Enum.filter(&(&1 != ""))
  end

  def match_values([],[]), do: {:ok, ["/"], %{}}
  def match_values([], path_info), do: {:error, "No route matching", "/#{Enum.join(path_info,"/")}"}
  def match_values([route|routes], path_info) do
    case match_route_elements(route,path_info) do
      {:ok, params} ->
        {:ok, route, params}
      :not_found -> 
        match_values(routes, path_info)
    end
  end

  # match_route_elements/2
  def match_route_elements([r_head|r_tail], [r_head|p_tail]), do: match_route_elements(r_tail,p_tail,%{})
  def match_route_elements(_routes,_path_info), do: :not_found

  # match_route_elements/3
  def match_route_elements([],[],params), do: {:ok, params}
  def match_route_elements([":"<> param_id|r_tail], [param|p_tail],params) do 
    params = Map.put(params,param_id,param)
    match_route_elements(r_tail,p_tail,params)
  end
  def match_route_elements([r_head|r_tail], [r_head|p_tail],params), do: match_route_elements(r_tail,p_tail,params)
  def match_route_elements(_routes,_path_info,_params), do: :not_found

end