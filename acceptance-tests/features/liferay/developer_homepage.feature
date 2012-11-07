Feature: Developer HomePage Tests
 Devs should see dev homepage
  
Background:
Given I have an open web browser
When I navigate to the Portal home page

@RALLY_US570 @RALLY_US576 @RALLY_US575 @RALLY_US1200
@wip
Scenario: Developer sees developer homepage
When I select "Shared Learning Collaborative" and click go
And I was redirected to the "Simple" IDP Login page  
When I submit the credentials "slcdeveloper" "slcdeveloper1234" for the "Simple" login page	 
And I should see "Developer Home"
And I should see Developer Checklist
