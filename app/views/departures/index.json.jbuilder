json.array!(@departures) do |departure|
  json.extract! departure, :id, :day_type, :hour, :minute, :bus_stop_id
  json.url departure_url(departure, format: :json)
end
