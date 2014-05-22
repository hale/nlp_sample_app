json.array!(@keywords) do |keyword|
  json.extract! keyword, :id, :name, :metaphone, :stem
  json.url keyword_url(keyword, format: :json)
end
