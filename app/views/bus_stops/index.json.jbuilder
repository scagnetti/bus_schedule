json.array!(@bus_stops) do |bus_stop|
  json.extract! bus_stop, :id, :name, :direction_id
  json.url bus_stop_url(bus_stop, format: :json)
end
