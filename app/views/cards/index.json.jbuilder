json.array!(@cards) do |card|
  json.extract! card, :template_id, :title, :properties
  json.url card_url(card, format: :json)
end
