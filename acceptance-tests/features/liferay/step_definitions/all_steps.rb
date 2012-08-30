require 'rubygems'
require 'selenium-webdriver'
require_relative '../../utils/selenium_common.rb'

When /^I navigate to the Portal home page$/ do
  @driver.get PropLoader.getProps['portal_server_address'] + PropLoader.getProps['portal_app_suffix']
end

When /^I select "([^"]*)" and click go$/ do |realmName|
 realm_select = @driver.find_element(:name=> "realmId")
  
  options = realm_select.find_elements(:tag_name=>"option")
  found = false
  options.each do |option|
    if (option.text == realmName)
      found = true
      option.click()
      break
    end
  end
  assert(found, "The exact realm cannot be found")
  goButton =@driver.find_element(:id, "go")
  goButton.click
end

Then /^I should see Admin link$/ do
  @driver.find_element(:link_text, "Admin")
end

Then /^I should not see Admin link$/ do
  adminLink = @driver.find_elements(:link_text,"Admin")
  assert(adminLink.length == 0, "Admin link was found")
end

Then /^I click on log out$/ do
  menuList = @driver.find_element(:class, "menu_n").find_element(:class, "first_item")
  menu = menuList.find_element(:id,"menulink")
  menu.click
  menuList.find_element(:link_text, "Logout").click
  assertWithWait("User didn't log out properly") {@driver.current_url != PropLoader.getProps['portal_server_address'] + PropLoader.getProps['portal_app_suffix']}
end

Then /^I should be on the home page$/ do
  home = @driver.find_element(:class, "sli_home_title")
  assert(home.text == "HOME", "User is not on the portal home page. Current URL: " + @driver.current_url)
  if (@driver.page_source.include?("d_popup"))
    accept = @driver.find_element(:xpath, "//input[@value='Agree']")
    puts "EULA is present"
    accept.click
  else
    puts "EULA has already been accepted"
  end
end

Then /^I should be on the authentication failed page$/ do
   @driver.page_source.include?('Invalid')
end

Then /^I should be on the admin page$/ do
  title = @driver.find_element(:class, "sli_home_title").text
  assert(title == "ADMIN", "User is not in the admin page")
end

Then /^(?:|I )should see "([^\"]*)"$/ do |text|
  body = @driver.find_element(:tag_name, "body")
  assert((body.attribute('innerHTML').include? text) == true, "Body doesn't contain #{text}")
end

Then /^(?:|I )should not see "([^\"]*)"$/ do |text|
  body = @driver.find_element(:tag_name, "body")
  assert((body.attribute('innerHTML').include? text) == false, "Body contains #{text}")
end

When /^I click on Admin$/ do
  clickOnLink("Admin")
end

And /^I should see logo$/ do 
  logo = @driver.find_element(:class, "company-logo")
  text = @driver.find_element(:class, "sli_logo_main").text
  assert(text == "SLC", "Expected: SLC, Actual: {#text}")
end

And /^I should see footer$/ do
  footer = @driver.find_element(:class, "portlet-body")
end

And /^I should see username "([^"]*)"$/ do |expectedName|
  name = @driver.find_element(:class, "first_item").text
  assert(name == expectedName, "Expected: #{expectedName} Actual: #{name}")
end

Then /^under System Tools, I click on "(.*?)"$/ do |link|
  clickOnLink(link)
end

Then /^under Application Configuration, I click on "(.*?)"$/ do |link|
  clickOnLink(link)
end

Then /^under My Applications, I click on "(.*?)"$/ do |link|
  links = @driver.find_elements(:tag_name, "a")
  links.each do |availableLink|
    if (availableLink.text.include? link)
      yLocation = availableLink.location.y.to_s
      xLocation = availableLink.location.x.to_s
      @driver.execute_script("window.scrollTo(#{xLocation}, #{yLocation});")
      availableLink.click
      break
    end
  end
end

Then /^under Application Configuration, I see the following: "(.*?)"$/ do |links|
  section = @driver.find_element(:id, "column-5")
  verifyItemsInSections(links, section, "Application Configuration")
end

Then /^under System Tools, I see the following "(.*?)"$/ do |links|
  section = @driver.find_element(:id, "column-4")
  verifyItemsInSections(links, section, "System Tools")
end

Then /^under My Applications, I see the following apps: "(.*?)"$/ do |apps|
  myApps = @driver.find_element(:id, "column-4")
  verifyItemsInSections(apps, myApps, "My Applications")
end

Then /^I switch to the iframe$/ do
  wait = Selenium::WebDriver::Wait.new(:timeout => 15) 
  wait.until{(iframe = isIframePresent()) != nil}
end

Then /^I exit out of the iframe$/ do
  @driver.switch_to.default_content
end

Then /^I click on the SLC Logo$/ do
  logo = @driver.find_element(:class, "sli_logo_main")
  links = logo.find_elements(:tag_name,"a")
  links[1].click
end

def isIframePresent()
  #TODO figure out how to determine when page is loaded instead of using sleep
  sleep 2
  @driver.switch_to.default_content
  begin
    iframe = @driver.find_element(:tag_name, "iframe")
    puts "iframe found"
    @driver.switch_to.frame(iframe.attribute('id'))
    puts "iframe switched"
    # This might not be a good solution that works for all
    @driver.find_element(:id,"messageContainer")
    puts "iframe contents appears to be loaded"
    return iframe
  rescue  
    puts "iframe not fully loaded yet"
    @driver.switch_to.default_content
    return nil
  end 
end

def clickOnLink(linkText)
  @driver.find_element(:link, linkText).click
end

def verifyItemsInSections(expectedItems, section, sectionTitle)
  listOfItems = expectedItems.split(';')
  title = section.find_element(:class, "portlet-title-text")
  assert(title.text == sectionTitle, "Expected: #{sectionTitle} Actual: #{title}")
  all_trs = section.find_element(:class, "portlet-body").find_elements(:tag_name, "tr")
  listOfItems.each do |item|
    found = false
    all_trs.each do |tr|
      if (tr.text.include? item)
        found = true
        break
      end
    end
    assert(found,"#{item} was not found in My Applications")
  end
end

### TODO 
### CLEAN UP REQUIRE FOR THE CODE BELOW ##################################
Then /^I follow all the wsrp links$/ do
  begin
    wsrp_elements= []
    #  wsrp_elements=@driver.find_elements(:xpath, "//section   [@id='portlet_appselectioninterfaceportlet_WAR_AppSelectionInterfaceportlet']/div/div/div/table/tbody/tr/td/a")
    @driver.find_elements(:xpath, "//a[@href='#']").each do |tt|
      if  tt.attribute('onclick') != nil && tt.attribute('onclick').match('callWsrp')
        wsrp_elements << tt
      end
    end
    wsrp_elements.compact!
    wsrp_ele=[]
    wsrp_elements.each do |wsrp|
      wsrp_ele << wsrp.attribute('onclick').gsub("callWsrp","").gsub("(","").gsub(")","").gsub("'","")
    end
   
    wsrp_ele.each do |el|

      @driver.navigate.to el
      #puts "@RALLY-US1193---Ref-141-As an IT admin, I want SLI Portal to include existing applications/components that exist in my state/district."
      puts "successfully open #{el}"
    end
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
    
end

Then /^I am on the wsrp page$/ do
  begin
    text=@driver.find_element(:tag_name => "title").text()
    puts text
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end

end

Then /^I should see "([^"]*)" as "([^"]*)"$/ do |field,text|

  begin
    if @driver.find_element(:id, field).text == text
      val=true
    else
      val=false
      puts "DEFECT:-The Description text box retains earlier text after reporting a problem"
    end
   
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
end


And /^I see the EULA Page$/ do
  begin
    ele=@driver.find_element(:xpath, "//input[@value='Agree']")
    ele2=@driver.find_element(:xpath, "//input[@value='Logout']")
    element=true
  rescue
    element=false
  end
  if element == true
    true
  else
    puts "SLI Exception"
  end 
end
