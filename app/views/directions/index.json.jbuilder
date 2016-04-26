json.array!(@directions) do |direction|
  json.extract! direction, :id, :display_name, :line_id
  json.url direction_url(direction, format: :json)
end
