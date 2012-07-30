Feature:  WSRP Tests
 Navigate to wsrp link successfully using SSD Realm under 'Select an Application' page
 
 Background:
Given I have an open web browser
When I navigate to the Portal home page 

 @wip
Scenario: SSD Realm with wsrp link click
Then I am on the Realm selection page
Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
When I login with "rrogers" and "rrogers1234"
Then I should be on the home page
Then I should see " Dashboard"
Then I follow all the wsrp links

@wip
Scenario:Admin User with wsrp link click
    When I login with "demo" and "changeit"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow all the wsrp links

@wip 
Scenario: check wsrp of district admin user and go to admin page
Then I am on the Realm selection page
Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
When I login with "rrogers" and "rrogers1234"
#this is normal user 
Then I should be on the home page
Then I should see "Admin"
Then I follow "Admin"
Then I should be on the admin page
Then I follow all the wsrp links

@RALLY_US570 @RALLY_US576 @RALLY_US575@RALLY_US1193@RALLY_US1200
Scenario: check wsrp of admin user and go to admin page
When I select "Shared Learning Infrastructure" and click go
And I was redirected to the "Simple" IDP Login page  
When I submit the credentials "slcoperator" "slcoperator1234" for the "Simple" login page 
Then I should be on the home page
Then I should see Admin link
Then I follow "Admin"
Then I should be on the admin page
Then I follow all the wsrp links
 
@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1193 @RALLY_US1200
Scenario:  check wsrp of admin user and go to admin page
When I select "Shared Learning Infrastructure" and click go
And I was redirected to the "Simple" IDP Login page  
When I submit the credentials "sunsetrealmadmin" "sunsetrealmadmin1234" for the "Simple" login page 
Then I should be on the home page
Then I should see Admin link
Then I follow "Admin"
Then I should be on the admin page
Then I follow all the wsrp links
