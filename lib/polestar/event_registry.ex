defmodule Polestar.EventRegistry do
  require Logger

  @test_routes ["users/:id/profile","users/:id/profile/edit","users/:id","course/:course_id/module/:id"]

  def lookup(path_info) do
    Logger.debug "Path info #{inspect path_info}"
    match(path_info)
  end

  def match(path_info) do
    path_info
    |> filter_by_length
    |> match_values(path_info)
  end

  def filter_by_length(path_info) do
    #TODO routes can be converted to a list on creation
    Enum.map(@test_routes, &route_info/1) 
    |> Enum.filter fn(route) ->
      Enum.count(path_info) == Enum.count(route)
    end
  end

  def route_info(route) do
    route
    |> String.split("/")
    |> Enum.filter(&(&1 != ""))
  end

  def match_values([],[]), do: {:ok, ["/"], %{}}
  def match_values([], path_info), do: {:error, "No route matching /#{Enum.join(path_info,"/")}"}
  def match_values([route|routes], path_info) do
    case match_route_elements(route,path_info) do
      {:ok, params} ->
        {:ok, route, params}
      :error -> 
        {:error, "No route matching /#{Enum.join(path_info,"/")}"}
    end
  end

  def match_route_elements([r_head|r_tail], [r_head|p_tail]), do: match_route_elements(r_tail,p_tail,%{})
  def match_route_elements([],[],params), do: {:ok, params}
  def match_route_elements([":"<> param_id|r_tail], [param|p_tail],params) do 
    params = Map.put(params,param_id,param)
    match_route_elements(r_tail,p_tail,params)
  end
  def match_route_elements([r_head|r_tail], [r_head|p_tail],params), do: match_route_elements(r_tail,p_tail,params)
  def match_route_elements(_routes,path_info), do: :error
  def match_route_elements(_routes,path_info,_params), do: :error

end