json.array!(@messages) do |msg|
  json.from msg.from.username
  json.message msg.message
  json.sent msg.created_at
end
