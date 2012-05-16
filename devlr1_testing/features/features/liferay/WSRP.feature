Feature: title
 Navigate to wsrp link successfully using SSD Realm under 'Select an Application' page
  


 
  @wip
  Scenario:-SSD Realm with wsrp link click
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "rrogers" and "rrogers1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow all the wsrp links
    
    @wip
   Scenario:-Admin User with wsrp link click
    Given I have an open web browser
    When I go to the login page
    #Then I click "Go"
    When I login with "demo" and "changeit"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow all the wsrp links
   
  Scenario:check  wsrp of admin user and go to admin page
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "rrogers" and "rrogers1234"
    Then I should be on the home page
    Then I should see "Admin"
    Then I follow "Admin"
    Then I should be on the admin page
    Then I follow all the wsrp links

