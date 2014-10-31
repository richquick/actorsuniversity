json.array!(@followings) do |following|
  json.extract! following, :follower_id, :pursued_id
  json.url following_url(following, format: :json)
end
