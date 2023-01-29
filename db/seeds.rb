# Create a few accounts
admin = Account.create(email: 'fake1@test.com', username: 'finance_dude', password: 'pass1234', status: :verified)
5.times { Account.create(email: Faker::Internet.email, username: Faker::Internet.username(separators: %w[_], specifier: 3..20), password: Faker::Internet.password, status: :verified) }
accounts = Account.all

# Create communities
Community.create(sub_dir: 'KO', description: 'Community dedicated to Coca Cola ($KO)! We like the drink and love the stock!')
Community.create(sub_dir: 'SHOP', description: 'For all things Shopify! Discuss trends, investment ideas, and anything related to $SHOP!')
Community.create(sub_dir: 'TSLA', description: "The hub for all things related to the stock of electric vehicle pioneer, Tesla Inc. Share your thoughts on the future of Tesla's stock performance and stay up-to-date on the latest financial developments. Let's drive the conversation forward!")
Community.create(sub_dir: 'AAPL', description: "Welcome to c/AAPL, a community for individuals interested in the latest news, analysis, and discussion about the stock performance of tech giant, Apple Inc. From earnings reports to market trends, this subreddit serves as a platform for investors, traders, and enthusiasts to share their thoughts and opinions on the company's financial success.")
Community.create(sub_dir: 'GOOG', description: "c/GOOG is a community dedicated to discussing the stock performance of tech giant, Google. From earnings reports to market trends, join investors, traders, and enthusiasts in exploring the latest news and analysis on the company's financial success. Share your thoughts on the future of Google's stock and stay up-to-date on the latest developments in the tech industry. Come join the conversation!")
communities = Community.all

# Create posts
10.times { Post.create(title: Faker::Lorem.paragraph(sentence_count: rand(1..2)), body: Faker::Lorem.paragraph(sentence_count: rand(1..30)), community: communities.sample, account: accounts.sample) }
posts = Post.all

# Set your fake account to admin for all communities
communities.each { |c| Membership.create(account: admin, community: c) }

# Create top level comments
25.times { Comment.create(body: Faker::Lorem.paragraph(sentence_count: rand(1..20)), account: accounts.sample, commentable: posts.sample) }

# Create nested comments
50.times { Comment.create(body: Faker::Lorem.paragraph(sentence_count: rand(1..20)), account: accounts.sample, commentable: Comment.all.sample) }

# Create votes
possible_votes = ['upvote', 'downvote']

accounts.each do |account|
  # Don't make votes for our own account
  next if account == admin

  # Have account vote on each post
  posts.each { |post| post.votes.create(account: account, vote: possible_votes.sample) }

  # Vote on random sample of comments
  comments = Comment.order('RANDOM()').limit(10)
  comments.each { |comment| comment.votes.create(account: account, vote: possible_votes.sample) }
end
