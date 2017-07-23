We are making a system to manage logistics of meal delivery. There are multiple delivery zones and restaurants, each restaurant has many meals and can deliver to multiple zones each day. Every day different restaurants rotate to a different zone. For example, on Monday restaurant A and B will deliver to zone1 while restaurant C and D deliver to zone2, on Tuesday restaurant A and B will deliver to zone2 while restaurant C and D deliver to zone1, etc.

1. Design a scheduling system that an admin can set restaurants on each day for a delivery zone.

2. Design an API that responds json that includes all meals for a specific day in a specific zone, so the request will be something like ?zone_id=1&day=monday.

3. Design an API for restaurant owners, so that they can remove a meal on-the-fly. Authentication is required for them to be able to consume that API. 

4. Add all designs or validations that you think will improve the system.

5. Write tests in rspec.