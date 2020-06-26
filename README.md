# User Clock-In-Clock-Out Challenge

## Install

- Install Ruby on Rails and Postgresql - https://gorails.com/setup/osx/10.15-catalina
- bundle install
- rails s

## How did I approach this challenge?

- In approaching this, I took a look at the required specifications (allow a user to clock-in/clock-out, store the events), but I built upon it for an administrator to see the events and see how long a person worked for.
- So in the front-end, I designed the following views (ClockIn/Out page, User Sign Up page, Admin's Users page, Admin's User page, and the Event Logs page) to determine what endpoints were needed for each view.
- When a user clock's in, it creates a clocked in event. When a user clock's out, it creates 2 entries in the DB. The clock out event. But it also creates a WORK LOG event that specifies when a user clocked in and clocked out, and also the time worked between the 2 events.
- The WORK LOG event is used to help calculate the total amount worked, which in turn would assist in helping calculate pay for a given time period.
- The WORK LOG is also the mechanism I used for the functionality of being able to edit clock events. For example, a person forgets to clock out, or clock in, the time_worked field would fall between weird boundaries and would be flagged for review.

## What schema did I choose and why?

- Since I was using Ruby on Rails, I went with Postgresql, meaning I chose to use a relational database.
- I chose it because choosing a non-relational db would not suffice for the functionality required.
- I used an events table to store all the data of clocking in and out. Putting it in a document and growing that document would have suffered performance as the number of entries grew.
- I created work log table as an assist to calculating time worked, rather than doing all calculations against the events table at time of need.

## If given another day, or another month, how would I build on this?

- Please see the Future Considers section below.

### End Points

USERS

- GET /users -> Get list of all users (used in Admin's Users page)
- GET /user/:id -> Get info for specific user (used in Admin's User page)
- POST /users -> Create a user from a username (used in User Sign Up page)
- PUT /users/:id -> Update a user (used to change the User's username, not used anywhere currently)
- DELETE /users/:id -> Archive a user (used from the Admin's User page)

EVENTS

- GET /events -> Get list of all events, can be filtered by username param (used in Admin's User page and Event Logs page)
- GET /events/:id -> Get a specific event (not used anywhere)
- POST /events -> Used to clock in/out. By passing in the body type, "clock", it specifies to clock in/out. Can also be used in the future to log other types of events (used in the Clock In/Out page)

WORK LOGS

- GET /work_logs -> Get list of all work logs, can be filtered by username param
- GET /work_logs/:id -> Get specific work log (not used anywhere)
- PUT /work_logs/:id -> Edit specific work log (used in Admin's User page). This will also change the corresponding event's and time_worked values.
- DELETE /work_logs/:id -> Will mark a work log's status as invalid (not used anywhere). Was created for future payment options to mark work as to be not counted.

## Future Considerations

- Add Testing. Add unit tests. Add integration tests. Add regression tests. Add acceptance tests.
- Build on the User model. Add password, JWT token, for login and verification. Add role, Admin vs Teacher vs (other?).
- Put in AUTHENTICATION endpoints to handle logging in.
- Make the POST /events call a JWT protected call. Meaning a user must be logged in to make this call. Otherwise, anyone can clock in given a username.
- Make the end points dependent on login. So make some endpoints public, other private, others private based on User privileges.
- Put in more potential error handling on the clock in/out endpoint. To prevent spamming of the button. Maybe make use of a locking mechanism or check.
