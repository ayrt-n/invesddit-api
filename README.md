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

