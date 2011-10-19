@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to save the content

  Background:
    Given I am on an editable page
    And save results will be cached


  Scenario: A user can change content in an editable region and save those changes
    When I set the content of the editable region to "new content"
    And I click on the "Save" button
    Then the save should have "new content" for the editable region


  Scenario: A user can change content in a markupable region and save those changes
    When I set the content of the markupable region to "new content"
    And I click on the "Save" button
    Then the save should have "new content" for the markupable region


  Scenario: A user can put snippets into an editable region and get the options on save
    # todo: finish


  Scenario: A user can expect the right version of the snippet options to be saved
    # todo: finish


  Scenario: A user can put snippets into a markupable region and get the options on save
    # todo: finish
