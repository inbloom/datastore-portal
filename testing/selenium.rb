#for run this file just use "ruby filename" 
require 'selenium-webdriver'
#require 'watir-webdriver' #install gem selenium-webdriver
#require "watir-webdriver/extensions/alerts"
driver = Selenium::WebDriver.for :firefox
driver.navigate.to "https://devlr1.slidev.org"
a=driver.find_element(:name,'realmId') #realmId should be the html tag name of select tag
options=a.find_elements(:tag_name=>"option") # all the options of that select tag will be selected
options.each do |g|
if g.text == "Shared Learning Infrastructure"
g.click
break
end
end
ele=driver.find_element(:id, "go")
ele.click
element = driver.find_element(:id, 'IDToken1') #the username field id is IDToken1
element.send_keys "demo"
element = driver.find_element(:id, 'IDToken2') #the username field id is IDToken2
element.send_keys "changeit"
element=driver.find_element(:class, "Btn1Def")
element.click

#driver.navigate.to "https://devlr1.slidev.org"
wait = Selenium::WebDriver::Wait.new(:timeout => 100) # seconds
wait.until { driver.find_element(:link => "Admin") }
element=driver.find_element(:link, 'Admin')
element.click
wait = Selenium::WebDriver::Wait.new(:timeout => 100) # seconds
wait.until { driver.find_element(:link => "Sign Out") }
element=driver.find_element(:link, 'Sign Out')
element.click


driver.navigate.to "https://devlr1.slidev.org"
a=driver.find_element(:name,'realmId') #realmId should be the html tag name of select tag
options=a.find_elements(:tag_name=>"option") # all the options of that select tag will be selected
options.each do |g|
if g.text == "Shared Learning Infrastructure"
g.click
break
end
end
ele=driver.find_element(:id, "go")
ele.click
element = driver.find_element(:id, 'IDToken1')
element.send_keys "educator"
element = driver.find_element(:id, 'IDToken2')
element.send_keys "educator1234"
element=driver.find_element(:class, "Btn1Def")
element.click
if driver.find_element(:id, 'aui_3_4_0_1_226').displayed?
driver.find_element(:id, 'aui_3_4_0_1_226').click
else
wait = Selenium::WebDriver::Wait.new(:timeout => 100) # seconds
wait.until { driver.find_element(:link => "Logout") }

element=driver.find_element(:link, 'Logout')
element.click
end

