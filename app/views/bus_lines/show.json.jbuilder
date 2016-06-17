json.(@bus_line, :id, :name)
json.directions @bus_line.directions do |direction|
	json.id direction.id
  json.name direction.name
  json.url direction_url(direction, format: :json)
end
