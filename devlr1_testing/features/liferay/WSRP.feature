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
     #@RALLY-US1193---Ref-141-As an IT admin, I want SLI Portal to include existing applications/components that exist in my state/district.
    
    @wip
   Scenario:-Admin User with wsrp link click
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    #Then I click "Go"
    When I login with "demo" and "changeit"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow all the wsrp links
    #@RALLY-US1193---Ref-141-As an IT admin, I want SLI Portal to include existing applications/components that exist in my state/district.
  @wip 
  Scenario:check  wsrp of admin user and go to admin page
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "rrogers" and "rrogers1234"
    #this is normal user 
    Then I should be on the home page
    Then I should see "Admin"
    Then I follow "Admin"
    Then I should be on the admin page
    Then I follow all the wsrp links
    #@RALLY-US1193---Ref-141-As an IT admin, I want SLI Portal to include existing applications/components that exist in my state/district.
@RALLY_US570
@RALLY_US576
@RALLY_US575
@RALLY_US1193
@RALLY_US1200
@wip
Scenario:check  wsrp of admin user and go to admin page
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "5a4bfe96-1724-4565-9db1-35b3796e3ce1"
    #Then I click "Go"
    When I login with "slcoperator" and "slcoperator1234"
    #this is normal user 
    Then I should be on the home page
    Then I should see "Admin"
    Then I follow "Admin"
    Then I should be on the admin page
    Then I follow all the wsrp links
    #@RALLY-US1193---Ref-141-As an IT admin, I want SLI Portal to include existing applications/components that exist in my state/district.

@RALLY_US570
@RALLY_US576
@RALLY_US575
@RALLY_US1193
@RALLY_US1200
@wip
Scenario:check  wsrp of admin user and go to admin page
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "5a4bfe96-1724-4565-9db1-35b3796e3ce1"
    #Then I click "Go"
    When I login with "sunsetrealmadmin" and "sunsetrealmadmin1234"
    #this is normal user 
    Then I should be on the home page
    Then I should see "Admin"
    Then I follow "Admin"
    Then I should be on the admin page
    Then I follow all the wsrp links
    #@RALLY-US1193---Ref-141-As an IT admin, I want SLI Portal to include existing applications/components that exist in my state/district.


