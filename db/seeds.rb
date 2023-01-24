# Create a few accounts
account1 = Account.create(email: 'fake1@test.com', password: 'pass1234')
account2 = Account.create(email: 'fake2@test.com', password: 'pass1234')
account3 = Account.create(email: 'fake3@test.com', password: 'pass1234')

# Create community
community1 = Community.create(sub_dir: 'KO')
community2 = Community.create(sub_dir: 'SHOP')

# Create posts
post1 = Post.create(title: 'New post', body: 'new post', account: account1, community: community1)
post2 = Post.create(title: 'New post', body: 'new post', account: account1, community: community1)
post3 = Post.create(title: 'New post', body: 'new post', account: account1, community: community2)

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
