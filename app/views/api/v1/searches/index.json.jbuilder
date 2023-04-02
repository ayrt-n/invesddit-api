json.data do
  # Render results partials based on name of model being searched
  case @results.name
  when 'Post'
    json.array! @results do |result|
      # Post Data
      json.partial! 'api/v1/posts/post', post: result

      # Posts Communtiy Data
      json.community { json.partial! 'api/v1/communities/community', community: result.community }

      # Posts Author (Account) Data
      json.account { json.partial! 'api/v1/accounts/account', account: result.account }
    end
  when 'Community'
    json.array! @results do |result|
      # Community Data
      json.partial! 'api/v1/communities/community', community: result
    end
  when 'Account'
    json.array! @results do |result|
      # Account Data
      json.partial! 'api/v1/accounts/account', account: result
    end
  else
    []
  end
end
