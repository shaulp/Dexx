json.array!(@templates) do |template|
  json.extract! template, :name, :packed_properties
  json.url template_url(template, format: :json)
end
