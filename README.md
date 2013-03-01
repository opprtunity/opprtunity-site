# README

## Notes

### API portion

> Implement a function that can be run at different intervals (e.g., when a new user signs up, what a user changes their "needs" and "offerings", scheduled from a rake task) that matches two users based upon their "needs" and "offers" -- see Additional Info below for more info. So whenever this process is triggered for a single user, it would search through the DB and find any matching user based upon needs/offers and insert them into the database as a match (if they didn't already exist) and send out emails to both users.

Instead of a periodic rake task, I opted for queueing the matching using the `sucker_punch` gem (easily changed to Resque for scalability). This gives a more "real time" feel to the application. Later on, we can then do the emails based on user preferences e.g. I'd prefer to be notified in real time, or once a day, or once a week. Also, this way someone can get a visual notification in real time separate from their email notification.

* As of this challenge (number 2037) we don't have enough use cases to determine the correct indices to create. Some initial indices have been created that are almost certain to contribute to app performance, but don't forget to create indices as needed!
* The same is true with validations. Right now only the `first_name`, `last_name` and `email` fields are validated with presence while the urls are validated through a regex; the other fields may or may not be optional depending on the requirements. Don't forget to put in validations as/when they are required!
* The requirements speak of "top matches." However, there is no information as to how a match is calculated. Most likely we can add a new field called `score` that is an integer out of 10000 ( == 100.00 so we avoid float computations) depending on how closely the need and offering correlates with each other (this is just a guess, we don't have an idea as of this challenge how this score is calculated). Then a default scope that orders matches in descending score order can be applied (and maybe even paginated).
* We're using the banged version of `create!` and `update!` to make sure the API throws any error to the client. Since we're an API, we assume that client-side access can be from a third-party; hence we don't try to second-guess their intentions and just fail fast. Client-side code should take care to catch these errors.
* The `UsersController` use two different kinds of `User` models -- one for the index that does not expose any of the nested attributes, and a child that inherits and overrides serializable_hash so we can expose whatever attributes we want. Note that this behavior might change depending on the requirements. If you also want to expose the nested attributes in the index (not sure why you'd want to) or add extra attributes, you can always create your own child model and override the function at that point.
* We are using `rspec` for testing and `factory-girl` for generating seed data. We don't have complete coverage yet, mostly because as of this writing not all requirements are known. Most of the tests for the known requirements have already been implemented though to help with regression testing.
* We are using the `sextant` gem so you can always see the routes at http://localhost:3000/rails/routes

Here are the routes as of now:

     matches_user GET    /:version/users/:id/matches(.:format)           users#matches {:version=>/(1)/, :format=>"json"}
    upcoming_user GET    /:version/users/:id/meetings/upcoming(.:format) users#upcoming {:version=>/(1)/, :format=>"json"}
        past_user GET    /:version/users/:id/meetings/past(.:format)     users#past {:version=>/(1)/, :format=>"json"}
            users GET    /:version/users(.:format)                       users#index {:version=>/(1)/, :format=>"json"}
                  POST   /:version/users(.:format)                       users#create {:version=>/(1)/, :format=>"json"}
         new_user GET    /:version/users/new(.:format)                   users#new {:version=>/(1)/, :format=>"json"}
        edit_user GET    /:version/users/:id/edit(.:format)              users#edit {:version=>/(1)/, :format=>"json"}
             user GET    /:version/users/:id(.:format)                   users#show {:version=>/(1)/, :format=>"json"}
                  PUT    /:version/users/:id(.:format)                   users#update {:version=>/(1)/, :format=>"json"}
                  DELETE /:version/users/:id(.:format)                   users#destroy {:version=>/(1)/, :format=>"json"}

Note that only the users controller have support for full REST; we're currently awaiting the next challenges to figure out how exactly to edit th eother collection entries. Change the http verb restrictions in `routes.rb` as needed.

## Deployment

* See this [tutorial](http://robdodson.me/blog/2012/04/27/how-to-setup-postgresql-for-rails-and-heroku/) for more info.

Take note (from the linked article)

> Here’s one little gotcha that I seemed to run into. If you try to access your site on Heroku using the `heroku open` command you might get an error page. You have to make sure to also call `heroku run rake db:create:all` otherwise your production database will not be in place and your app will fail to connect to it. Speaking of production databases, you should also note that Heroku will overwrite whatever you put into your `config/database.yml` so you don’t have to worry about figuring out all the connection details for their shared services…it’ll all just work. Sweet!

rake db:drop && rake db:create && rake db:migrate && rake db:seed
* Next do the migrations `heroku run rake db:migrate`
* If you want you can run `heroku run rake db:seed` for some dummy data (mostly taken from challenge 2036)
* Then open your app `heroku open`

## Demo

You can see a live demo here: http://thawing-fortress-1965.herokuapp.com (this is on a free heroku sandbox, so the initial page load might take a few seconds while heroku is spinning up the instance)

(user # 3 is Bob Poole, the guy from challenge 2036)

Here are a few sample URLs

* [http://thawing-fortress-1965.herokuapp.com/1/users](http://thawing-fortress-1965.herokuapp.com/1/users)
* [http://thawing-fortress-1965.herokuapp.com/1/users/3](http://thawing-fortress-1965.herokuapp.com/1/users/3)
* [http://thawing-fortress-1965.herokuapp.com/1/users/3/meetings/past](http://thawing-fortress-1965.herokuapp.com/1/users/3/meetings/past)
* [http://thawing-fortress-1965.herokuapp.com/1/users/3/matches](http://thawing-fortress-1965.herokuapp.com/1/users/3/matches)