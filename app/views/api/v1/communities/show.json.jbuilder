json.data do
  json.partial! 'api/v1/communities/community', community: @community
  json.is_member @roles.include?('member')
  json.is_admin @roles.include?('admin')
end
