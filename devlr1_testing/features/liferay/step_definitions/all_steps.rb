require 'rubygems'
require 'selenium-webdriver'
#require_relative '/../utils/sli_utils.rb'
require_relative '../../utils/selenium_common.rb'





Then /^I am on the Realm selection page$/ do
  @driver.navigate.to ENV['api_server_url']
end

Then /^I select "([^\"]*)"$/ do |text|
  begin
    a=@driver.find_element(:name,'realmId') #realmId should be the html tag name of select tag
    options=a.find_elements(:tag_name=>"option") # all the options of that select tag will be selected
    options.each do |g|
      if g.attribute('value') == text || g.text == text
        g.click
        break
      end
    end
    ele=@driver.find_element(:id, "go")
    ele.click
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#     elsif Timeout::Error
#      puts "TimeOut error"

    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
 
end

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
#   elsif Timeout::Error
#      puts "TimeOut error"
   
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
#    elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end

end


Then /^I select "([^\"]*)" from "([^\"]*)"$/ do |text,field|
  begin
    #wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    # wait.until{
    a=@driver.find_element(:id, field)
    options=a.find_elements(:tag_name=>"option")
    options.each do |g|
      if g.attribute('value') == text || g.text == text
        g.click
        break
      end
    end
    # }
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
end




Then /^I click "([^\"]*)"$/ do |btn_text|
  begin
    ele=@driver.find_element(:id, "go")
    ele.click
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#     elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  #@driver.find_element(:xpath, "//form/input[@value=#{btn_text}]").click
end 

Given /^EULA has been accepted$/ do

end

When /^I go to the login page$/ do
  @driver.navigate.to ENV['api_server_url']
   puts ""
  begin
    a=@driver.find_element(:name,'realmId') #realmId should be the html tag name of select tag
    ele=true
    if ele == true
      options=a.find_elements(:tag_name=>"option") # all the options of that select tag will be selected
      options.each do |g|
        if g.attribute('value') == '2012lh-d8135101-cc75-11e1-b0fd-066c72649ec8'
		
          g.click
          break
        end
      end

      ele=@driver.find_element(:id, "go")
      ele.click
    end
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  

  
end


Then  /^I follow the home page Dashboard$/ do 
  begin
    
    #element= @driver.find_element(:xpath, "//td/a/div[text()=' Dashboard (Integration)']")
    element= @driver.find_element(:xpath, "//td/a/div[text()=' Dashboard']")
    element.click
   # puts "--@RALLYUS184-I would like the ability to see all administrative/operator functions that are available to me."
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
end

Then /^I should logged out$/ do
  #begin
  #@driver.find_element(:link, 'Sign Out').click
  #rescue
  begin
  
    
    #action=Selenium::WebDriver::ActionBuilder.new(:move_to,nil)
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) 
    wait.until{
      menu = @driver.find_elements(:class,"menulink").first.click()
      submenu=@driver.find_element(:link, 'Logout')
      submenu.click }
    #@driver.action.move_to(menu).perform
  rescue
   
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
   
  end
  #submenu=@driver.find_element(:link, 'Logout')
   
  #@driver.action.move_to(menu).click(submenu).perform
  
  #click_link('Logout')
end

Then /^I should be on the home page$/ do
# puts "@RALLY_US576--Ref-128- As any user I see a portal home page with a listing of applications available to me."
# puts "@RALLYUS575----I want a common UI element to return to SLI home page that I may place in my app as I please"
  begin
    ele=@driver.find_element(:xpath, "//input[@value='Agree']")
    element=true
     
  rescue
    element=false
  end

  if element
    ele.click
  else
    puts "EULA has been accepted."
  end
  begin
    
    #action=Selenium::WebDriver::ActionBuilder.new(:move_to,nil)
    #@driver.action.move_to(menu).perform
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) 
    wait.until{
      menu = @driver.find_elements(:class,"menulink").first.click()
      submenu=@driver.find_element(:link, 'Logout').displayed? }
  rescue Selenium::WebDriver::Error::NoSuchElementError, Timeout::Error, NoMethodError
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"
    elsif NoMethodError
      puts ""
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  #submenu=@driver.find_element(:link, 'Logout').displayed?
 
   
  #@driver.find_element(:link, 'Sign Out').displayed?

end


And /^I see the EULA Page$/ do
# puts "--@RALLYUS1200---Ref-130 As a user logging in for the first time, I must click through a EULA acceptance."
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



When /^I mouseover on menu and click submenu "([^\"]*)"$/ do |submenu|
  begin
    
    #action=Selenium::WebDriver::ActionBuilder.new(:move_to,nil)
    #@driver.action.move_to(menu).perform
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    wait.until{
      menu = @driver.find_elements(:class,"menulink").first.click()
      @driver.find_element(:link, submenu).click()}
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#   elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  #submenu=@driver.find_element(:link, 'Logout')
  # submenu.click
   


end




Given /^I should remove all cookies$/ do
  @driver.manage.delete_all_cookies
end

When /^I login with "([^\"]*)" and "([^\"]*)"$/ do |username, password|
#puts "@RALLYUS1200--Ref-130 As a user logging in for the first time, I must click through a EULA acceptance."
  begin
    @driver.manage.delete_all_cookies
    begin
    element = @driver.find_element(:id, 'user_id') 
    rescue
     element= @driver.find_element(:name, 'IDToken1')
    end
 #the username field id is IDToken1
    element.send_keys username
    begin
     element = @driver.find_element(:id, 'password') #the username field id is IDToken2 
    rescue 
     element= @driver.find_element(:name, 'IDToken2')
    end     

    element.send_keys password
    begin
     element=@driver.find_element(:id, "login_button")
    rescue
      element=@driver.find_element(:class, "Btn1Def") 
    end
    element.click
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  #wait = Selenium::WebDriver::Wait.new(:timeout => 100) # seconds
  # wait.until { driver.find_element(:link => "Logout") }
end
Then /^I should be on the authentication failed page$/ do
  begin
   @driver.page_source.match('Authentication failed.')
   # @driver.navigate.to "https://devapp1.slidev.org/sp/UI/Login"
  rescue
 
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#   elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  
end

Then /^I click button "([^\"]*)"$/ do |text|
  begin
    wait = Selenium::WebDriver::Wait.new(:timeout => 100)
    wait.until { @driver.find_element(:xpath, "//span/input[@value='#{text}']")
      @driver.find_element(:xpath, "//span/input[@value='#{text}']").click
  
    }
  
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"

    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  
end

Then /^I should be on the admin page$/ do
  #begin
  #wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  #wait.until{
  if @driver.find_element(:link, "Admin").displayed? 
    puts "On the admin Page"
  else
    puts "Not an admin Page"
  end
  #  }
  
  #rescue

  #if @driver.page_source.match('SLI Exception')
  #     ele=false
  #     puts "SLI Exception"
  #   elsif Timeout::Error
  #    puts "TimeOut error"

  #   else
  #    raise   Selenium::WebDriver::Error::NoSuchElementError
  # end
  #end

end

And /^I select the "([^\"]*)"$/ do |sel|
  #wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  #wait.until{
  select=@driver.find_element(:tag_name, 'select')
  options=select.find_elements(:tag_name, "option")

  options.each do |g|
    if g.attribute('value') == sel
      g.click
      break
    end
  end


end


And /^I click "([^\"]*)"$/ do |btn|
   
  
end

Then /^It open a popup$/ do
#puts "---@RALLYUS578--Ref-136- As a user, I want to be able to report application and/or data problems so that they can be fixed and/or provide feedback on an application."
begin
  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  wait.until{
    frame=@driver.find_element(:tag_name, "iframe")
    @driver.switch_to.frame(frame)
  
  }
rescue
  puts "Iframe is not detected"

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
    #elsif Timeout::Error
  #    puts "TimeOut error"
#     elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
   
end

Then /^I fill "([^"]*)" from "([^"]*)"$/ do |arg1, arg2|
  begin
    @driver.find_element(:id, arg2).send_keys arg1
  rescue Selenium::WebDriver::Error::NoSuchElementError, Timeout::Error
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
    #elsif Timeout::Error
      #puts "TimeOut error"
#    elsif Timeout::Error
#      puts "TimeOut error"
    elsif Selenium::WebDriver::Error::NoSuchElementError
      puts ""
    else
      puts ""
      # raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
end

Then /^I close the browser$/ do
  @driver.quit
end




Then /^(?:|I )should see "([^\"]*)"$/ do |text|
  begin
   links=[]
    links << @driver.find_elements(:tag_name, 'p')  
    links << @driver.find_elements(:tag_name, 'span')
    links << @driver.find_elements(:tag_name, 'div')
  links.flatten!
  ele=false
  links.each do |link|
    if link.text.match(text)
      ele=true
      puts "Message has been displayed successfully"
      break
    end
  end
 if ele == true
  puts "Message has been displayed successfully"
 else
  puts ""
 end
 rescue Selenium::WebDriver::Error::StaleElementReferenceError,Timeout::Error
  puts ""
 end
 
end




Then /^(?:|I )should not see "([^\"]*)"$/ do |text|
  begin
    link=@driver.find_element(:link, text).displayed? || @driver.find_element(:name, text).displayed?
    link=true
  rescue
    link=false
  end 
  link
end


When /^(?:|I )follow "([^\"]*)"$/ do |link|
  begin
    @driver.find_element(:link, link).click
  rescue
    if @driver.page_source.match('SLI Exception')
      ele=false
      puts "SLI Exception"
#    elsif Timeout::Error
#      puts "TimeOut error"
    else
      raise   Selenium::WebDriver::Error::NoSuchElementError
    end
  end
 
end


And /^I should see LOGO$/ do 
#puts "--@RALLYUS581-Ref-134-I want to be able to see a common header & footer UI that conforms to SLI standards. "
 begin
  text=@driver.find_element(:xpath, "//div[@class='menu_n']/h1[@class='sli_logo_main']/a/span").text()
  if text.match("SLC")
   puts text 
  else
   puts "SLC text not found"
  end
 rescue
  puts "No Such Element"
 end
end

And /^I should see footer$/ do
 #puts "@RALLYUS581--Ref-145 As a user, I see a common legal notice about data privacy across apps."
  begin
   element=@driver.find_element(:xpath, "//div[@id='p_p_id_footerportlet_WAR_headerfooterportlet_']/div[@class='portlet-body']")
   puts element.text()
  rescue
   puts "No Such Element"
  end
end

And /^I should see username$/ do
  begin
   element=@driver.find_element(:xpath, "//ul[@class='menu_n']/li[@class='first_item']/a")
   puts element.text()
  rescue
    puts "No such Elements"
  end
end


Then /^I am selecting the first value from "([^\"]*)"$/ do |field|
    a=@driver.find_element(:id,field) #realmId should be the html tag name of select tag
    options=a.find_elements(:tag_name=>"option")[1].click
    
end

