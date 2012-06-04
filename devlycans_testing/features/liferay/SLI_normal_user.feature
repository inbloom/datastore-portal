Feature: title
  In order to keep control of website information the expectation of the results 
  As an normal User If you login, you should not see SLI administrator 

  #Background:
    #Given a normal user exists with "educator" and "educator1234"
   
 @RALLY_US570
 @RALLY_US1200
 Scenario: Normal User Login with wrong username and password
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    When I login with "lkim" and "lkim"
    Then I should be on the authentication failed page
    Then I should see "Authentication failed."
    
 #Scenario: Normal User Login with blank username and blank password
   # When I go to the login page
   # When I login with "" and ""
   # Then I should be on the authentication failed page
   # Then I should see "Invalid User Name or password"   
 @wip
 Scenario: Normal User Login for SLI
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    #Given I should remove all cookies
    When I login with "slcoperator" and "slcoperator1234"
    Then I should be on the home page
    Then I should not see "Admin"
    Then I should logged out
@RALLY_US570
@RALLY_US576
@RALLY_US575
@RALLY_US1200
  Scenario: Normal User Login for SSD
   Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    #this is normal user
    Then I should be on the home page
    Then I should not see "Admin"
    Then I should logged out
    
  
