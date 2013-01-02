Feature: Header and footer tests
  In order to keep control of website information the expectation of the results 
  for all users should see HEADER Footer

Background:
Given I have an open web browser
When I navigate to the Portal home page 

@wip
Scenario:check sli logo and user name in header and footer for admin user 
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    When I login with "rrogers" and "rrogers1234"
   #this is admin user
    Then I should see Admin link
    And I should see SLI LOGO
    And I should see username "rrogers"
    And I should see footer  

@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200 @RALLY_US581
Scenario: check sli logo and user name in header and footer for admin user 
When I select "Shared Learning Collaborative" and click go
And I was redirected to the "Simple" IDP Login page  
When I submit the credentials "slcoperator" "slcoperator1234" for the "Simple" login page 
Then I should be on the home page
Then I should see Admin link
And I should see logo
And I should see username "SLC Operator"
And I should see footer
Then I click on Admin
And I should see logo
And under System Tools, I see the following "Approve Application Registration;Change Password"

@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200 @RALLY_US581
Scenario:check sli logo and user name in header and footer for normal user 
 When I select "Illinois Daybreak School District 4529" and click go
And I was redirected to the "Simple" IDP Login page
When I submit the credentials "linda.kim" "linda.kim1234" for the "Simple" login page
Then I should be on the home page   
And I should see logo
And I should see username "Mrs Linda Kim"
And I should see footer      
