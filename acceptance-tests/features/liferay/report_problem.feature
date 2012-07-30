Feature: Report a Problem
  In order to keep control of website information the expectation of the results 
  for report a problem it should have to work 

Background:
Given I have an open web browser
When I navigate to the Portal home page

 @RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200 @RALLY_US578  
Scenario: Report a problem 
When I select "Illinois Daybreak School District 4529" and click go
And I was redirected to the "Simple" IDP Login page
When I submit the credentials "linda.kim" "linda.kim1234" for the "Simple" login page
Then I should be on the home page
And I click on Report a Problem
Then It open a popup
Then I select problem type "Other Feedback"
Then I type "Test" in Problem Description
Then I click on Report a Problem Button
Then I should see "This field is mandatory." 
