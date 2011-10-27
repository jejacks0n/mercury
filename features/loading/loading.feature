@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to expect the editor to load properly

  Background:
    Given I am on an editable page


  Scenario: A user can expect to see the toolbar
    Then I should see "Save" within the toolbar
    And I should see "Preview" within the toolbar
    And I should see "Bold" within the toolbar


  Scenario: A user can expect to see the contents of the iframe
    Then I should see "Editable region" in the content frame


  Scenario: A user can expect to see the status bar
    Then I should see "Mercury Editor v0.2.3" within the statusbar
