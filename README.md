# Invesddit - A Finance Related Content Aggregation and Discussion Website

## Summary

Invesddit is a finance related content aggregation and discussion website. While there are a variety of finance related forums across the web (e.g., [Stockhouse.com](https://www.stockhouse.com), [TheCoBF.com](https://thecobf.com), [ValueInvestorsClub.com](https://valueinvestorsclub.com)), the user interfaces tend to be dated and features are limited. All-in-all, these websites are in need of an update!

As part of the final project for [The Odin Project](https://www.theodinproject.com/lessons/javascript-javascript-final-project), I was tasked with replicating one of my favorite websites as closely as possible. For my final project I wanted to build a competitor to these finance forums with an updated user interface and rich set of features, all inspired by one of my favorite websites - Reddit.

As a result, Invesddit was born!

This repository is for the backend Ruby on Rails API for Invesddit. You can find more information on the frontend React application [here](https://github.com/ayrt-n/invesddit).

## Set up

### Using Web Brower (Recommended)

The simplest way to view Invesddit is live on Github at https://ayrt-n.github.io/invesddit/

Please note that it may take 30-45 seconds for the Heroku dyno to start up if the application has been inactive for awhile.

### Using Local Machine

If you want to run the Invesddit backend API locally on your own machine you will first need to install [Ruby](https://guides.rubyonrails.org/v5.0/getting_started.html), [Rails](https://guides.rubyonrails.org/v5.0/getting_started.html), and [PostgreSQL](https://medium.com/geekculture/postgresql-rails-and-macos-16248ddcc8ba).

With those installed, clone this repo to a fresh directory and navigate to the root directory. From there, create and migrate the database by running:

```rails db:create db:migrate```

Optionally, you may add some seed data by running:

```rails db:seed```

Once that is finished, you can start the backend server by running:

```rails s -p 3001```

The backend should now be running on your localhost, port 3001. With that going, you are now able to start working with the API, either by using a service like Postman or curl in the terminal, or setting up the React fronend by following the instructions withing the associated repo [here](https://github.com/ayrt-n/invesddit).

## Sample API Queries

Once the server is running on localhost, there are a number of different queries which can be run to test any of the functionality. Some examples as follows:

Query main post feed:
```
curl http://localhost:3000/api/v1/posts
```

Create an account:
```
curl -d '{"login":<EMAIL ADDRESS>,"username":<USERNAME>,"password":<PASSWORD>,"password-confirm":<PASSWORD CONFIRMATION>}' -H 'Content-Type: application/json' http://localhost:3001/create-account
```

Login (Get JWT token for authorized requests):
```
curl -d '{"login":<EMAIL ADDRESS>,"password":<PASSWORD>}' -H 'Content-Type: application/json' http://localhost:3001/login
```

Create new community:
```
curl -d '{"sub_dir":"META","title":"META Investors Club","description":"Place to discuss all things Meta stock"}' -H 'Content-Type: application/json' -H 'Authorization: <JWT Token>' http://localhost:3001/api/v1/communities,
```

## Database Structure

The database currently consists of five separate but related tables, as follows (excluding Account verification and recovery-related and Active Storage-related tables):

[Insert ER Diagram]

Accounts:
- The Accounts table consist of a a number of columns related to the user authentication (e.g., email and password), the users public profile (e.g., username), as well as a counter cache for notifications
- An Account has_many (0,..,n) Posts
- An Account has_many (0,..n) Comments
- An Account has_many (0,..n) Notifications
- An Account has_many (0,..n) Memberships
- An Account has_many (0,..n) Communities through Memberships

Posts:
- Accounts are able to create TextPosts, MediaPosts, or LinkPosts, depending on what type of content they are interested in sharing. All posts consist of a title, while TextPosts and LinkPosts have a body, and MediaPosts have an associated image
- Posts have a number of cached values (e.g., upvotes, downvotes, score, hot rank, confidence score, comments count) used to efficiently display post data and sort posts when generating user feeds
- Additionally, Posts contain a column for status (either Published or Deleted) to allow for soft deletion
- A Post has_many (0,..,n) Comments
- A Post has_many (0,..,n) Votes
- A Post belongs_to (via foreign key, required) a Community
- A Post belongs_to (via foreign key, required) an Account

Comments:
- Accounts are able to comment on posts and/or reply to other comments. Comments consist of a body string as well as a status for Published or Deleted to allow for soft deletion (like posts)
- Comments may be infinitely nested as comments may be in response to other comments
- Comments have a number of cached values (e.g., upvotes, downvotes, score, hot rank, confidence score) used to efficiently display comment data and sort comments when generating the comment section
- A Comment has_many (0,..,n) Votes
- A Comment has_many (0,..,n) Replies (Comments)
- A Comment has_many (0,..,n) Notifications
- A Comment belongs_to (via foreign key, required) an Account
- A Comment belongs_to (via foreign key, required) a Post

Votes:
- Similar to most other content aggregation website, Accounts are able to upvote content (Posts or Comments) that they enjoy and downvote content that they do not like. The Votes table records votes for this content as well as the vote type (upvote or downvote)
- To keep track of and prevent duplicate votes, the Vote table needs to track both the Account and Votable (Post of Comment) that was voted on
- A Vote belongs_to (via foreign key, required) an Account
- A Vote belongs_to (via foreign key and polymorphic type column, required) a polymorphic Votable

Communities:
- Communities are the Invesddit equivalent of sub-Reddits, allowing Accounts to set up and participate in different discussion forums/communities focused around topics of interest
- Communities currently consist of a sub directory (sub_dir), used to identify communities and generate URLs (e.g., https://ayrt-n.github.io/invesddit/c/NVDA), a title used to give the community a more human readable name, and description.
- Additionally, the communities table has a column for keeping track of the number of members at a given time (memberships_count) to efficiently display that information to users
- A Community has_many (0,..,n) Posts
- A Community has_many (0,..,n) Memberships
- A Community has_many (0,..,n) Admins through Memberships
- A Community has_many (0,..,n) Members through Memberships
- In order to modify Community informaiton (e.g., title, description), a user must be an Admin

Memberships:
- Accounts may be a part of many communities and Communities have many accounts which participate in the Community. The Memberships table helps to record the relationship between Accounts and Communities
- The role column on the Memberships table indicates what the Accounts role is in the Community. Currently, Accounts may either participate in a Community as a member (1) or admin (2)
- A Membership belongs_to (via foreign key, required) an Account
- A Membership belongs_to (via foreign key, required) a Community 

Notifications:
- Accounts have notifications to help alert them to content they might be interested in, as well as let them know when other users are engaging with their content
- A Notification belongs_to (via foreign key and polymorphic type column, required) Notifiable (e.g., a Post or Comment)
- A Notification belongs_to (via a foreign key, required) an Account
