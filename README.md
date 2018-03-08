# Requirements

We are making a system for admins to manage logistics of meal delivery. There are many delivery zones and restaurants. Each restaurant has many meals and is scheduled to deliver to at most 3 delivery zones everyday. Each delivery zone can have at most 4 restaurants everyday. For example, on Monday restaurant A and B will deliver to zone1 while restaurant A and C deliver to zone2; on Tuesday restaurant B will deliver to zone2 while restaurant C deliver to zone1, etc. The system needs to generate and manage the schedule automatically. Repeated assignments should be minimized, which means a restaurant should not be assigned to the same delivery zone repeatedly unless it has been assigned to every other delivery zone (users in each delivery zone want to see different restaurants everyday).

Design and implement this system using Ruby on Rails and satisfy the user stories below. Please write your specs using RSpec and views using HAML.

# User Stories

## Data structure and CRUD

* As an admin, I can create, view, update, and delete meals.
* As an admin, I can create, view, update, and delete restaurants.
* As an admin, I can create, view, update, and delete delivery zones.
* As an admin, given a restaurant, R and a delivery zone, Z, I can specify that R must never be scheduled to deliver to Z.
* As an admin, for each restaurant, I can view the delivery zones that this restaurant can never be scheduled for delivery.
* As an admin, given a restaurant, R, I can specify that R is always closed on Tuesday (or on any one or more days of the week), and thus must never be scheduled to any delivery zone on any Tuesday from now on.
* As an admin, for each restaurant, I can view the days of a week that this restaurant can never be scheduled for delivery.
* As an admin, I can view a delivery schedule for the past and next 7 days. This delivery schedule should allow me to determine the delivery zones that any given restaurant is scheduled to deliver to, on any one of those 14 days. Schedules in the past should be immutable.

## API

* Provide an API endpoint that accepts a delivery zone id and a date. This endpoint returns the JSON serialization of all restaurants and their meals that are scheduled for the given delivery zone and on the given date. For example, the url params can look like `?zone_id=1&day=2018-01-02`.
* Add authentication for the above API so that the endpoint takes an additional parameter - api_key. Each api_key should be specific to one restaurant. The above endpoint should return an error message if the key is not found. Please apply proper security considerations if the keys are persisted in the database.

# Considerations

* Please include proper instructions on how to setup and run your submission.
* Please use recent versions of Ruby on Rails, RSpec, HAML, and PostgreSQL.
* We understand much of code design comes from future considerations. However, in a code challenge like this, future consideration is nonexistent. Therefore, do not overthink. Do not overengineer. Make assumptions but be sure to note them in your submission.
* UI should be minimalistic. Make reasonable effort on UX and feel free to comment on future improvement ideas.
* You do NOT have to include user authentication unless you want to. The term 'admin' does NOT imply authentication.

# Submission

Please fork this repo and open a PR against master.
