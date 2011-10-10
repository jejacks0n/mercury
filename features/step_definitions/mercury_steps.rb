## Generic web steps
#------------------------------------------------------------------------------
When /^(?:|I )click on (.+)$/ do |selector|
  selector = selector_for(selector)
  find(selector, :message => "Unable to locate the element '#{selector}' to click on").click
end

Then /^(.+) should (not )?be visible$/ do |selector, boolean|
  selector = selector_for(selector)
  if boolean == 'not '
    page.has_no_css?("#{selector}")
  else
    page.has_css?("#{selector}", :visible => true)
  end
end


## Mercury general steps
#------------------------------------------------------------------------------
# scope step for the mercury content frame
When /^(.*) in the content frame$/ do |step|
  page.driver.within_frame('mercury_iframe') { When step }
end

# step for silencing mercury's onbeforeunload confirmation
Given /^the editor won't prompt when leaving the page$/ do
  page.driver.execute_script('Mercury.silent = true')
end


## Toolbar specific steps
#------------------------------------------------------------------------------
When /^(?:|I )select (.*?) from the dropdown$/ do |selector|
  selector = selector_for(selector)
  find(selector, :message => "Unable to locate the element '#{selector}' to click on").click
end


## Region specific steps
#------------------------------------------------------------------------------
Given /^the content of (.*?) (?:is|are) (.*?)$/ do |region_selector, contents|
  When "I set the contents of #{region_selector} to #{contents}"
end

Then /^the contents? of (.*?) should be "([^"]*)"$/ do |region_selector, content|
  region_id = region_id_for(region_selector, false)
  page.driver.within_frame('mercury_iframe') do
    find("##{region_id}", :message => "Unable to locate a region named '#{region_id}'")
    results = page.driver.execute_script <<-JAVASCRIPT
      element = document.getElementById('#{region_id}')
      if (element.getAttribute('data-type') == 'markupable') {
        return element.value;
      } else {
        return element.innerHTML;
      }
    JAVASCRIPT
    assert_equal content, results.gsub('"', "'")
  end
end

When /^(?:|I )(?:change|set) the contents? of (.*?) to (.*?)$/ do |region_selector, contents|
  region_id = region_id_for(region_selector, false)
  content = contents[0] == '"' ? contents : "\"#{contents_for(contents)}\""
  page.driver.within_frame('mercury_iframe') do
    find("##{region_id}", :message => "Unable to locate a region named '#{region_id}'")
    page.driver.execute_script <<-JAVASCRIPT
      element = document.getElementById('#{region_id}')
      if (element.getAttribute('data-type') == 'markupable') {
        element.childNodes[0].value = #{content};
      } else {
        element.innerHTML = #{content};
      }
    JAVASCRIPT
  end
end

When /^(?:|I )(?:make|have) a selection$/ do
  # assume the first span in the first editable region if nothing was provided
  When("I have a selection in the editable region")
end

When /^(?:|I )(?:make|have) a selection in (.*?)$/ do |region_selector|
  region_id = region_id_for(region_selector, false)
  page.driver.within_frame('mercury_iframe') do
    find("##{region_id}", :message => "Unable to locate a region named '#{region_id}'")
    page.driver.execute_script <<-JAVASCRIPT
      element = document.getElementById('#{region_id}')
      if (element.getAttribute('data-type') == 'markupable') {
        alert('unimplemented')
      } else {
        selection = new top.Mercury.Regions.Editable.Selection(window.getSelection(), document)
        selection.selectNode(element.getElementsByTagName('span')[0]);
      }
    JAVASCRIPT
  end
end


## Saving specific steps
#------------------------------------------------------------------------------
Given /^save results will be cached$/ do
  page.driver.execute_script <<-JAVASCRIPT
    Mercury.PageEditor.prototype.oldSerialize = Mercury.PageEditor.prototype.serialize;
    Mercury.PageEditor.prototype.serialize = function() {
      results = this.oldSerialize.call(this, arguments);
      window.cachedResults = results;
      return results;
    }
  JAVASCRIPT
end

Then /^the save should have (.*?) for (.*?)$/ do |contents, region_selector|
  region_id = region_id_for(region_selector, false)
  content = contents[0] == '"' ? contents : "\"#{contents_for(contents)}\""
  results = page.driver.execute_script("return window.cachedResults['#{region_id}']['value']")
  assert_equal content, "\"#{results}\""
end
