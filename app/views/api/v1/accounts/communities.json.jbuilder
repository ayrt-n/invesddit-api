json.data do
  json.array! @communities do |community|
    json.partial! 'api/v1/communities/community', community:
  end
end
