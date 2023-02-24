json.data do
  json.partial! 'api/v1/communities/community', community: @community
  json.current_role @community.role(@current_account)
end
