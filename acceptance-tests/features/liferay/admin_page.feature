Feature: Admin Page Tests
  In order to keep control of website information the expectation of the results 
  for admin uses should see admin page
  
Background:
Given I have an open web browser
When I navigate to the Portal home page

@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200
Scenario:check admin user on admin page check 
When I select "inBloom" and click go
And I was redirected to the "Simple" IDP Login page  
When I submit the credentials "slcoperator" "slcoperator1234" for the "Simple" login page	 
Then I should see Admin link
Then I click on Admin
Then I should be on the admin page

 @RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200
 Scenario:check Non admin user and check admin page
When I select "Illinois Daybreak School District 4529" and click go
And I was redirected to the "Simple" IDP Login page 
When I submit the credentials "linda.kim" "linda.kim1234" for the "Simple" login page
Then I should be on the home page
Then I should not see "Admin" 

@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200@RALLY_US184
 Scenario: check district admin user on admin page check  
When I select "inBloom" and click go
And I was redirected to the "Simple" IDP Login page 
When I submit the credentials "sunsetrealmadmin" "sunsetrealmadmin1234" for the "Simple" login page
Then I should see Admin link
Then I click on Admin
Then I should be on the admin page
And under System Tools, I see the following "Manage Realm"
And I click on the SLC Logo
And I should be on the home page


 @wip
 Scenario:check admin user on admin page check  SLC administration to check Default SLI Roles.
 When I login with "demo" and "changeit"
 Then I should see Admin link
 Then I click on Admin
 Then I should be on the admin page
 When I follow "SLC Administration"
 Then I should see "Default SLI Roles"
 
