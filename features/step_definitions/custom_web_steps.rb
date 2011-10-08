# Scope step for mercury content frame
When /^(.*) in the content frame$/ do |step|
  page.driver.within_frame('mercury_iframe') { When step }
end