Feature: title
  In order to keep control of website information the expectation of the results 
  for admin uses should see admin page


  Scenario:check admin user and go to admin page
    Given I have an open web browser
    When I go to the login page
    When I login with "demo" and "changeit"
    Then I should see "Admin"
    Then I follow "Admin"
    Then I should be on the admin page
    
  Scenario:check Non admin user and check admin page
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb026a0-73be-4296-ad36-d9abf11e3757"
    #Then I click "Go"
    When I login with "mario.sanchez" and "mario.sanchez1234"
    Then I should be on the home page
    Then I should not see "Admin" 
 @wip
  Scenario:check admin user on admin page check  SLC administration to check Default SLI Roles
   Given I have an open web browser
    When I go to the login page
    When I login with "demo" and "changeit"
    Then I should see "Admin"
    Then I follow "Admin"
    Then I should be on the admin page
    When I follow "SLC Administration"
    Then I should see "Default SLI Roles"
 
