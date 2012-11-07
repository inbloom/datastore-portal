Feature: Admin Login Tests

Background:
Given I have an open web browser
When I navigate to the Portal home page
 When I select "Shared Learning Collaborative" and click go
And I was redirected to the "Simple" IDP Login page
 
@RALLY_US570 @RALLY_US1200
 Scenario: Admin User Login with wrong username and password
When I submit the credentials "dem" "change" for the "Simple" login page
Then I should be on the authentication failed page
  
@RALLY_US570  @RALLY_US575 @RALLY_US576 @RALLY_US1200
 Scenario: District Admin User Login
When I submit the credentials "sunsetrealmadmin" "sunsetrealmadmin1234" for the "Simple" login page
 Then I should be on the home page
 Then I should see Admin link
 Then I click on log out

@RALLY_US570  @RALLY_US575 @RALLY_US576 @RALLY_US1200
Scenario: Admin User Login
When I submit the credentials "slcoperator" "slcoperator1234" for the "Simple" login page
Then I should be on the home page
Then I should see Admin link
 Then I click on log out

 


 
  
