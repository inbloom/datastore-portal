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
Then I should see "SLC Dashboard"
Then I click on log out
    #Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    #Then I select "Daybreak School District 4529" from "edOrgSelect"
    #Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "No Filter" from "studentFilterSelector"
    #Then I should see "Salmon Burger"
    #Then I should see "Student Fake"
    #Then I should see "Raphael De Sliva"
    #Then I should see "Fabio De Silva"
  
  @wip
  Scenario:-User Login through SSD Realm and choose English Language Learner
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "English Language Learner" from "studentFilterSelector"
    #Then I should see "Salmon Burger"
    #Then I should see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake"
  @wip 
  Scenario:-User Login through SSD Realm and choose English Language Learner (former)
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "English Language Learner (former)" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake"

  @wip
  Scenario:-User Login through SSD Realm and choose Section 504
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
   # Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "Section 504" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake"
   @wip  
   Scenario:-User Login through SSD Realm and choose Section 504 (former)
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "Section 504 (former)" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake"  
    @wip
   Scenario:-User Login through SSD Realm and choose IEP
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "IEP" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake" 
   @wip 
   Scenario:-User Login through SSD Realm and choose IEP (former)
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    Then I should see "Learning Map"
    Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "IEP (former)" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake"
     
  @wip   
  Scenario:-User Login through SSD Realm and choose Custom Program
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "Custom Program" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake"   
   @wip
  Scenario:-User Login through SSD Realm and choose Repeating Grade
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "Repeating Grade" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Raphael De Sliva"
    #Then I should not see "Student Fake"  
    @wip
    Scenario:-User Login through SSD Realm and choose Reduced Lunch
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "Reduced Lunch" from "studentFilterSelector"
    #Then I should not see "Salmon Burger"
    #Then I should not see "Fabio De Silva"
    ##Then I should not see "Student Fake"   
    
    @wip
    Scenario:-User Login through SSD Realm and choose Free Lunch
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    Then I should see " Dashboard"
    Then I follow the home page Dashboard
    #Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    #Then I should see "             Select an application         "
    #Then I should see "Learning Map"
    #Then I should see "Dashboard"
    #Then I follow "Dashboard"
    Then I select "Daybreak School District 4529" from "edOrgSelect"
    Then I select "East Daybreak Junior High" from "schoolSelect"
    #Then I select "7th Grade English" from "courseSelect"
    #Then I select "7th Grade English - Sec. 3" from "sectionSelect"
    #Then I should see "ISAT Reading"
    #Then I select "Free Lunch" from "studentFilterSelector"
    #Then I should see "Salmon Burger"
    #Then I should see "Raphael De Sliva"
    #Then I should not see "Fabio De Silva"
    #Then I should not see "Student Fake"
  
