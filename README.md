# The Chowbus Admin

This app managees the assignments of scheduled deliveries for restaurants to designated areas.

## Setup

### Dependencies

1. Ruby 2.4.1
1. PostgreSQL 

### Configuration

Set any PostgreSQL configurations in the ```config/database.yml``` file.

### Local Installation

Run the following commands:
```
gem install bundle
bundle install
bundle exec rake db:create db:migrate
```

To populate the database with fake data:
```
bundle exec rake seed:chowbus seed:assignment
```

## Running Things

Run the following command:
```
rails s
```

## Demo

An instance of the app can be found here: [https://delivery-jayncoke.herokuapp.com](https://delivery-jayncoke.herokuapp.com)

---

## Using the API

All endpoints require the `api_key` parameter to be passed. Available ones can be retrieved from the database in the `users` table under the `api_key` column. A sample user should already exist after the data migration.

### Responses

Expect a successful response to be in [JSON](https://www.json.org/) in the following structure:

```
{
    data: {
        meta: {
            pagination: {
                current_page: <integer>,
                items_per_page: <integer>,
                total_items: <integer>,
                total_pages: <integer>
            }
        },
        output: <Array of retrieved objects>
    }
}
```

- `meta`: Contains meta data about the results
  - `pagination`: Contains pagination information
    - `current_page`: The current page of results being returned
    - `items_per_page`: The number of items per page result being returned
    - `total_items`: The total number of items that can be paged through
    - `total_pages`: Based on `items_per_page` and `total_items`, the total number of pages that can be paged through
- `output`: Contains the array of returned objects depending on the endpoint being called

### Failed Responses

When an error occurs, whether by a missing parameter or server error, the response will be in the following structure:

```
{
    data: {
        meta: {
            code: <integer>,
            message: <string>
        }
    }
}
```

- `meta`: Contains meta data about the response
  - `code`: The status code of the response
  - `message`: The error message

#### Error Status Codes

- 400: Bad Request
  - 400 can be caused by the following:
    - Missing required input parameter
    - Invalid input parameter
    - Input ID that doesn't exist
- 401: Forbidden
  - 401 is caused when the `api_key` isn't passed


### Pagination

The `page` parameter is optional. It is 1 by default. If a page that is greater than the total number of available pages is passed, a successful response is returned with a empty results.

The `count` parameter is optional. It is 10 by default. If a count greater than 50 is passed, it will cap automatically and return 50 maximum results.

---

## Admin 

If running locally, the Admin can be accessed at `http://localhost:3000`.

---

## API Endpoints

If running locally, the base host URL is `http://localhost:3000/`.

#### 1. /v1/assignments

This endpoint returns a page of Assignment results. By default, the results are ordered by oldest first.

##### Parameters

- `api_key`: string, required. The UUID key assigned to the client that must be passed to allow use of the API.
- `page`: integer, optional. Default: 1. The page of results to retrieve. 
- `count`: integer, optional. Default: 10. The number of items to retrieve per page.
- `zone_id`: integer, optional. ID of the delivery zone to filter results on.
- `day`: string, optional. Format: "YYYY-MM-DD". The delivery assignment date to filter results on.

##### Output Assignment Object

Each Assignment object represents a restaurant assigned to delivery zone on the specified date.

- `id`: integer, The ID of the Assignment
- `date`: string, The date of the Assignment. In the "YYYY-MM-DD" format.
- `delivery_zone`: Delivery Zone object, The delivery zone of the Assignment
  - `id`: integer, The ID of the Delivery Zone
  - `name`: string, The name of the Delivery Zone
- `restaurant`: Restaurant object, the restaurant of the Assignment
  - `id`: integer, The ID of the Restaurant
  - `name`: string, The name of the Restaurant
  - `meals`: array of Meal objects, the meals of the Restaurant
    - `id`: integer, The ID of the Meal
    - `name`: string, The name of the Meal
    
Example Assignment object:
```
{
    id: 25,
    date: "2018-04-11",
    delivery_zone: {
        id: 1,
        name: "Fulton Market"
    },
    restaurant: {
        id: 1,
        name: "Au Cheval",
        meals: [
            {
                id: 1,
                name: "Caesar Salad"
            },
            {
                id: 2,
                name: "Cheeseburger"
            }
        ]
    }
}
```

##### Example CURL Call

```
curl http://localhost:3000/v1/assignments?api_key=<api_key>&page=<page>&count=<count>&zone_id=<zone_id>&day=<day>
```
---

### Tests

Factories and tests are located in the `/spec` folder.

#### Setup

Make sure to setup the test database:
```
RAILS_ENV=test rake db:create db:migrate
```

#### Running

```
rspec spec
```

---

### Logging

Standard Rails logging still applies, but whenever an API returns an error message, a log is created in the `/log/api.errors.<ENVIRONMENT>.log` file.

Each log will have the following JSON message:

- `when`: datetime, The date and time the error occurred
- `what`: string, The message of the error
- `where`: string, The API path being called when the error occurred
- `who`: Object that contains more information of the error
  - `url`: string, The URL of the call when the error occurred
  - `verb`: string, The request method (GET, POST, DELETE, UPDATE)
  - `parameters`: object, The parameters passed to the call
- `how`: string, The backtrace of the error. This will only log for the `development` environment.

---

## Development Notes

I made to sure to implement a basic versioning system from the start (`/v1`) to ensure backwards compatability and that legacy apps continue to work in case new versions change the response or logical biz rules.

I chose to have the `api_key` read from the standard parameters rather than the header pretty much for ease of implementation. Ideally the clients using the API should not expose their keys to the public, meaning that they should not make calls directly from their browser apps but instead from their own secured servers. If the API is deemed to require much more security, we can make changes to require that the `api_key` be passed only via the header.

Additional Biz Rules:

- When restrictions are newly added (ie restaurant not allowed to deliver to a specific zone), future

Assumptions:

- Assignments are created on an on demand basis. Meaning, there are no automatic creations of assignments. Assignments can be created in the admin for a day at a time.
- When Restaurants are deleted, all dependent associations are also removed. This includes Meals, Restriction Rules, and Assignments either in the past, present, or future.
- The `api_key` for the API is bound to a Restaurant object. Thus I have Assignments being returned only for that Restaurant. I'm assuming that we'd want to enforce some kind of privacy to not allow Restaurants view the data of other Restaurants.

If I had more time or more freedom to increase the scope of this project:

- Currently, deleting resources actually deletes records from the database. Ideally, I'd preserve data as much as possible. So if a Restaurant should be deleted, I'd make it "inactive" with a new column flag like `is_active` and set it to `false`. Then this resource shouldn't be used in the future or viewed in the admin. The most relevant business use case for this is to view history of deliveries in the past for historical purposes.
- Much more comprehensive rspec tests. Right now, I focused a majority of time when creating tests around the biz rules for creating assignments as well as the API. There are no tests for the main admin at this time.
- Add a throttling system to prevent client users from abusing the API. Simple case would be to limit the number of calls per minute. If they go over the limit, restrict the data for some set amount of time.
- Implement a user login and session for the Admin.
- Add messaging or alerting functionality whenever an exception is thrown and logged.


---
---


# Requirements

We are making a system for admins to manage logistics of meal delivery. There are many delivery zones and restaurants. Each restaurant has many meals and can be scheduled to deliver to at most 3 delivery zones everyday. Each delivery zone can have at most 4 restaurants everyday. For example, on Monday restaurant A and B will deliver to zone1 while restaurant A and C deliver to zone2; on Tuesday restaurant B will deliver to zone2 while restaurant C deliver to zone1, etc. The system needs to generate and manage the schedule automatically. Repeated assignments should be minimized, which means a restaurant should not be assigned to the same delivery zone repeatedly unless it has been assigned to every other delivery zone (users in each delivery zone want to see different restaurants everyday).

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
