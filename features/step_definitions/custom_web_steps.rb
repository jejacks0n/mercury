## Generic web steps
#------------------------------------------------------------------------------
When /^(?:|I )click on (.+)$/ do |locator|
  selector = selector_for(locator)
  find(selector, :message => "Unable to locate the element '#{selector}' to click on").click
end

Then /^(.+) should (not )?be visible$/ do |locator, boolean|
  selector = selector_for(locator)
  if boolean == 'not '
    page.has_no_css?("#{selector}")
  else
    page.has_css?("#{selector}", :visible => true)
  end
end

# scoping step for different windows
When /^(.*) in the "([^"]*)" window$/ do |s, window|
  page.driver.within_window(window) do
    step(s)
  end
end
