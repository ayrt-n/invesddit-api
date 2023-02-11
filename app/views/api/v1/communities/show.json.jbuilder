json.data do
  json.partial! 'api/v1/communities/community', community: @community
  json.is_member @community.members.include?(@current_account)
end
