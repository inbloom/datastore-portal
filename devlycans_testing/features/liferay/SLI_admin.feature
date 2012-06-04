Feature: title
  In order to keep control of website information the expectation of the results 
  As an admin
  If you Login you should see SLI Administrator and as an normal User If you login, you should not see SLI administrator 

 # Background:

    #Given an admin user exists with "demo" and "changeit"
    
 
 Scenario: Admin User Login with wrong username and password
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    #Given I should remove all cookies
    When I login with "dem" and "change"
    Then I should be on the authentication failed page
    Then I should see "Invalid User Name or password"
  
 # Scenario: Admin User Login with blank username and password
    #Given I have an open web browser
    #When I go to the login page
    #Given I should remove all cookies
    #When I login with "" and ""
    #Then I should be on the authentication failed page
    #Then I should see "Authentication failed."  
    

 Scenario: Admin User Login
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    #Given I should remove all cookies
    When I login with "sunsetrealmadmin" and "sunsetrealmadmin1234"
    Then I should be on the home page
    Then I should see "Admin"
    Then I should logged out

 Scenario: Admin User Login
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    #Given I should remove all cookies
    When I login with "slcoperator" and "slcoperator1234"
    Then I should be on the home page
    Then I should see "Admin"
    Then I should logged out
 @wip
 Scenario: Admin User Login for SSD
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Given I should remove all cookies
    When I login with "rrogers" and "rrogers1234"
    #This is admin user
    Then I should be on the home page
    Then I should see "Admin"
    Then I should logged out
 


 
  
