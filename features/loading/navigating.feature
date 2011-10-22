@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to expect the editor to not get in the way when I navigate and submit forms

  Background:
    Given I adjust the configuration to have: "{nonHijackableClasses: ['lightview']}"
    And am on an editable page


  Scenario: A user can navigate links targeting _top
    When I follow "_top" in the content frame
    Then I should be on the test page


  Scenario: A user can navigate links targeting _blank
    When I follow "_blank" in the content frame
    Then I should be on the editable page
    And I should see "test_page" in the "/mercury/test_page" window


  Scenario: A user can navigate links targeting _self
    When I follow "_self" in the content frame
    Then I should be on the test page


  Scenario: A user can navigate links with no target set
    When I follow "[none]" in the content frame
    Then I should be on the test page


  Scenario: A user can navigate links that are ignored by configuration
    When I follow "_self .lightview" in the content frame
    Then I should be on the editable page


  Scenario: A user can navigate links targeting random windows
    When I follow "foo" in the content frame
    Then I should be on the editable page
    Then I should see "test_page" in the "foo" window


  Scenario: A user can submit forms targeting _top
    When I press "post _top" in the content frame
    Then I should be on the test page
    And I should see "post _top"


  # todo: intermittent failure
#  Scenario: A user can submit forms targeting _blank
#    When I press "post _blank" in the content frame
#    Then I should be on the editable page
#    And I should see "post _blank" in the "/mercury/test_page" window


  Scenario: A user can submit forms targeting _self
    When I press "post _self" in the content frame
    Then I should be on the test page
    And I should see "post _self"


  Scenario: A user can submit forms with no target set
    When I press "get [none]" in the content frame
    Then I should be on the test page
    And I should see "get [none]"


  Scenario: A user can submit forms that are ignored by configuration
    When I press "post _self .lightview" in the content frame
    Then I should be on the editable page


  Scenario: A user can submit forms targeting random windows
    When I press "get foo" in the content frame
    Then I should be on the editable page
    And I should see "get foo" in the "foo" window
