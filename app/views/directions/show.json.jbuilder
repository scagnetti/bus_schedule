json.(@direction, :id, :name)
json.bus_stops @direction.bus_stops do |bs|
	json.id bs.id
  json.name bs.name
  json.url bus_stop_url(bs, format: :json)
end