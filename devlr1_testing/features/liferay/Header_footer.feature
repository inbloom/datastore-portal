Feature: title
  In order to keep control of website information the expectation of the results 
  for all users should see HEADER Footer
@wip
Scenario:check sli logo and user name in header and footer for admin user 
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    When I login with "rrogers" and "rrogers1234"
   #this is admin user
    Then I should see "Admin"
    And I should see SLI LOGO
    And I should see username
    And I should see footer  


Scenario: check sli logo and user name in header and footer for admin user 
    Given I have an open web browser
    When I go to the login page
    #Given I should remove all cookies
    When I login with "slcoperator" and "slcoperator1234"
    Then I should be on the home page
    Then I should see "Admin"
    And I should see SLI LOGO
    And I should see username
    And I should see footer 

Scenario:check sli logo and user name in header and footer for normal user 
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    When I login with "linda.kim" and "linda.kim1234"
   #this is admin user
    
    And I should see SLI LOGO
    And I should see username
    And I should see footer      
