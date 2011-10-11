@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to insert characters that are otherwise hard

  Background:
    Given I am on an editable page
    And the editor won't prompt when leaving the page

  Scenario: A user can expect all this!


#  Scenario: A user can insert special characters
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Character" button
    Then the modal window should be visible
    And I should see "Special Characters" within the modal title

    When I click on the sweet snowman
    Then the modal window should not be visible
    And the contents of the editable region should be "this is ☃ <b>content</b>"
