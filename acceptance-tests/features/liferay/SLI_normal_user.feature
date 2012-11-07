Feature:  Educator Login Tests

Background:
Given I have an open web browser
When I navigate to the Portal home page
   
@RALLY_US570 @RALLY_US1200
Scenario: Normal User Login with wrong username and password
When I select "Shared Learning Collaborative" and click go
And I was redirected to the "Simple" IDP Login page
When I submit the credentials "lkim" "lkim" for the "Simple" login page
Then I should be on the authentication failed page

@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200
 Scenario: Normal User Login for SSD
When I select "Illinois Daybreak School District 4529" and click go
And I was redirected to the "Simple" IDP Login page
When I submit the credentials "linda.kim" "linda.kim1234" for the "Simple" login page
 Then I should be on the home page
 Then I should not see Admin link
 Then I click on log out
    
  
