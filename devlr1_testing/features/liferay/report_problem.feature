Feature: title
  In order to keep control of website information the expectation of the results 
  for report a problem it should have to work 

  #Background:
    #Given a normal user exists with "educator" and "educator1234"
 @RALLY_US570
 @RALLY_US576
 @RALLY_US575
 @RALLY_US1200
 @RALLY_US578  
  Scenario:Report a problem submission for SSD normal User
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    Then I am selecting the first value from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field1" 
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "Thank you!"
 
 @RALLY_US570
 @RALLY_US576
 @RALLY_US575
 @RALLY_US1200
 @RALLYUS578   
  
   Scenario:Report a problem non happy submission for SSD normal User
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "4cb03fa0-83ad-46e2-a936-09ab31af377e"
    #Then I click "Go"
    When I login with "linda.kim" and "linda.kim1234"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "This field is mandatory." 
  @wip  
  Scenario:Report a problem cancelation for SSD admin User for Happy submission
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "5a4bfe96-1724-4565-9db1-35b3796e3ce1"
    #Given I should remove all cookies
    When I login with "sunsetrealmadmin" and "sunsetrealmadmin1234"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    Then I am selecting the first value from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field1" 
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "Thank you!"
  
  @wip
  Scenario:Report a problem submission for SSD admin User for non Happy submission or blank submission
    Given I have an open web browser
    Then I am on the Realm selection page
    Then I select "5a4bfe96-1724-4565-9db1-35b3796e3ce1"
    #Given I should remove all cookies
    When I login with "sunsetrealmadmin" and "sunsetrealmadmin1234"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "This field is mandatory." 
   
 @RALLY_US570
 @RALLY_US576
 @RALLY_US575
 @RALLYUS1200
 @RALLYUS578 
  Scenario:Report a problem happy cancelation for SLI admin User
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    When I login with "slcoperator" and "slcoperator1234"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    Then I am selecting the first value from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field1" 
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "Thank you!"

 @RALLY_US570
 @RALLY_US576
 @RALLY_US575
 @RALLYUS1200
 @RALLYUS578 
Scenario:Report a problem happy cancelation for SLI admin User
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    When I login with "slcoperator" and "slcoperator1234"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "This field is mandatory." 
   
    #Then I should see "_1_WAR_webformportlet_INSTANCE_5SN4WTq6xBVJ_field2" as ""
  @wip
   Scenario:Report a problem happy cancelation for SLI admin User
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    When I login with "demo" and "changeit"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #Then It open a popup
    #Then I select "problem1" from "_1_WAR_webformportlet_INSTANCE_kxDp6zzr4xIr_field1"
    #Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_5SN4WTq6xBVJ_field2"
    #Then I click button "Cancel"
    #Then I should see "_1_WAR_webformportlet_INSTANCE_5SN4WTq6xBVJ_field2" as ""
    
   @wip
   Scenario:Report a problem non happy submission for SLI admin User
    Given I have an open web browser
    When I go to the login page
    #@RALLYUS570-- Ref 127 - As a user, I see a login screen that brings me to the SLI home page.
    When I login with "demo" and "changeit"
    Then I should be on the home page
    When I mouseover on menu and click submenu "Report a problem"
    #Then It open a popup
    #Then I click button "Report A Problem"
    #Then I should not see "The form information was sent successfully." 
     
    @wip
    Scenario: Report a problem happy submission for New York Realm User
     Given I have an open web browser
     Then I am on the Realm selection page
     Then I select "4cb026a0-73be-4296-ad36-d9abf11e3757"
     When I login with "mario.sanchez" and "mario.sanchez1234"
     Then I should be on the home page
     When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    Then I select "Incorrect Data" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field1"  
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "Thank you!"
     
    @wip
    Scenario: Report a problem non happy submission for New York Realm User
     Given I have an open web browser
     Then I am on the Realm selection page
     Then I select "4cb026a0-73be-4296-ad36-d9abf11e3757"
     When I login with "mario.sanchez" and "mario.sanchez1234"
     Then I should be on the home page
     When I mouseover on menu and click submenu "Report a problem"
    #When I follow "Report a Problem"
    Then It open a popup
    
    Then I fill "Some test Problems" from "_1_WAR_webformportlet_INSTANCE_W6Fvabb0rTf2_field2"
    Then I click button "Report a Problem"
    Then I should see "This field is mandatory." 
     
