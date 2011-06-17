Feature:
  As a content editor type person
  In order to manage content
  I should be able to edit content using a toolbar

  @javascript
  Scenario: A user can expect to see the editor load
    When I go to an edit page
    Then I should see "Save" within the toolbar
    And I should see "Preview" within the toolbar
    And I should see "Bold" within the toolbar