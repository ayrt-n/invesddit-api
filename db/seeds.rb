# Create a few accounts
account1 = Account.create(email: 'fake1@test.com', password: 'pass1234', username: 'finance_dude', status: :verified)
account2 = Account.create(email: 'fake2@test.com', password: 'pass1234', username: 'ls_hedgie')
account3 = Account.create(email: 'fake3@test.com', password: 'pass1234', username: 'bobby', status: :verified)

# Create community
community1 = Community.create(sub_dir: 'KO', description: 'Community dedicated to Coca Cola ($KO)! We like the drink and love the stock!')
community2 = Community.create(sub_dir: 'SHOP', description: 'For all things Shopify! Discuss trends, investment ideas, and anything related to $SHOP!')

# Create posts
post1 = Post.create(title: 'New post', body: 'new post', account: account1, community: community1)
post2 = Post.create(title: 'New post', body: 'new post', account: account1, community: community1)
post3 = Post.create(title: 'New post', body: 'new post', account: account1, community: community2)
Post.create(title: 'New post', body: 'new post', account: account1, community: community2)
Post.create(title: 'New post', body: 'new post', account: account2, community: community1)
Post.create(title: 'New post', body: 'new post', account: account3, community: community2)
Post.create(title: 'New post', body: 'new post', account: account2, community: community1)
Post.create(title: 'New post', body: 'new post', account: account2, community: community2)

# Create votes
post1.votes.create(vote: 1, account: account1)
post1.votes.create(vote: -1, account: account2)
post1.votes.create(vote: 1, account: account3)

# Create memberships
community1.memberships.create(account_id: account1.id, role: 'admin')
community1.memberships.create(account_id: account2.id)
community2.memberships.create(account_id: account1.id)
community2.memberships.create(account_id: account2.id)
community2.memberships.create(account_id: account3.id, role: 'admin')
