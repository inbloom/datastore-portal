Feature: title
Navigate to dashboard link successfully using New York Realm under 'Select an Application' page

Background:
Given I have an open web browser
When I navigate to the Portal home page	
  
@RALLY_US570 @RALLY_US1200
 Scenario:-User Login through SSD Realm with wrong username and password
When I select "Illinois Daybreak School District 4529" and click go
And I was redirected to the "Simple" IDP Login page
When I submit the credentials "linda" "linda.kim" for the "Simple" login page
Then I should be on the authentication failed page
    
@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200 
 Scenario:-User Login through SSD Realm and choose No filter
When I select "Illinois Daybreak School District 4529" and click go
And I was redirected to the "Simple" IDP Login page
When I submit the credentials "linda.kim" "linda.kim1234" for the "Simple" login page    
Then I should be on the home page
Then under My Applications, I see the following apps: "AuthorizeTestApp1"
Then I click on log out
 