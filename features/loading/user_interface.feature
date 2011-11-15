@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to interact with various user interface aspects of the editor

  Background:
    Given I am on an editable page

  Scenario: A user can expect all this!


#  Scenario: A user can view and close the about dialog
    When I click on the about the editor link
    Then I should see "Mercury Editor" within the lightview title
    And I should see "Mercury Editor is an open source HTML5 WYSIWYG editor written in Coffeescript using jQuery. The project has been released under the MIT license." within the lightview window
    And I should see "Project Home" within the lightview window
    And I should see "Project Source" within the lightview window

    When I click on the lightview overlay
    Then the lightview window should not be visible
    And the lightview overlay should not be visible


#  Scenario: A user can open and close select dropdowns
    When I click on the formatblock editor dropdown
    Then the formatblock select should be visible
    And I should see "Heading 1 <h1>" within the formatblock select

    When I click on the style editor dropdown
    Then the style select should be visible
    And the formatblock select should not be visible


#  Scenario: A user can open and close palette dialogs
    When I click on the background color editor button
    Then the background color palette should be visible

    When I click on the foreground color editor button
    Then the foreground color palette should be visible
    And the background color palette should not be visible


#  Scenario: A user can open and close a panel
    When I click on the "View History" button
    Then the history panel should be visible
    And I should see "Page Version History" within the history panel

    When I click on the "View History" button
    Then the history panel should not be visible


#  Scenario: A user can open and close a modal window
    When I click on the "Insert Link" button
    Then the modal window should be visible
    And the modal overlay should be visible
    And I should see "Insert Link" within the modal title
    And I should see "Standard Links" within the insert link modal

    When I click on the modal close button
    Then the modal window should not be visible
    And the modal overlay should not be visible

    When I click on the "Insert Link" button
    And click on the modal overlay
    Then the modal window should not be visible
    And the modal overlay should not be visible
