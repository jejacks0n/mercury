@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to insert and edit complex tables

  Background:
    Given I am on an editable page
    And the editor won't prompt when leaving the page

  Scenario: A user can expect all this!


#  Scenario: A user can insert a table
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Table" button
    Then the modal window should be visible
    And I should see "Insert Table" within the modal title

    When I click on the third cell in the first row
    And I add a column before it
    Then the table column count should be 4
    And the selected cell should be the forth cell in the first row

    When I add a column after
    Then the table column count should be 5
    And the selected cell should be the forth cell in the first row

    When I add a row after
    Then the table row count should be 3
    And the selected cell should be the forth cell in the first row

    When I add a row before
    Then the table row count should be 4
    And the selected cell should be the forth cell in the second row

    When I delete the column
    Then the table column count should be 4
    And a selected cell should not be visible

    When I click on the second cell in the second row
    And delete the row
    Then the table row count should be 3
    And a selected cell should not be visible

    When I click on the second cell in the second row
    And increase the colspan
    And click on the first cell in the first row
    And increase the rowspan
    And select "Right" from "Alignment"
    And fill in "Border" with "2"
    And fill in "Spacing" with "2"
    And press "Insert Table"
    Then the contents of the editable region should be "this is&nbsp;<table align='right' border='2' cellspacing='2'><tbody><tr><td rowspan='2'><br></td><td><br></td><td><br></td><td><br></td></tr><tr><td colspan='2'><br></td><td><br></td></tr><tr><td><br></td><td><br></td><td><br></td><td><br></td></tr></tbody></table> <b>content</b>"
    And the modal window should not be visible


#  Scenario: A user can edit a table after inserting one (in an editable region)
    Given the content of the editable region has a table
    And I make a selection

    When I click on the add row before editor button
    Then the table row count should be 3
    And the contents of the editable region should be "this is a <table><tbody><tr><td><br></td><td><br></td></tr><tr><td><span>1</span></td><td><span>2</span></td></tr><tr><td><span>3</span></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"

    When I click on the add row after editor button
    Then the table row count should be 4
    And the contents of the editable region should be "this is a <table><tbody><tr><td><br></td><td><br></td></tr><tr><td><span>1</span></td><td><span>2</span></td></tr><tr><td><br></td><td><br></td></tr><tr><td><span>3</span></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"

    When I click on the add column before editor button
    Then the column count should be 3
    And the contents of the editable region should be "this is a <table><tbody><tr><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><span>1</span></td><td><span>2</span></td></tr><tr><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><span>3</span></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"

    When I click on the add column after editor button
    Then the column count should be 4
    And the contents of the editable region should be "this is a <table><tbody><tr><td><br></td><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><span>1</span></td><td><br></td><td><span>2</span></td></tr><tr><td><br></td><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><span>3</span></td><td><br></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"

    When I click on the delete row editor button
    Then the table row count should be 3
    And the contents of the editable region should be "this is a <table><tbody><tr><td><br></td><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><span>3</span></td><td><br></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"

    When I make a selection
    And click on the delete column editor button
    Then the table column count should be 3
    And the contents of the editable region should be "this is a <table><tbody><tr><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><br></td><td><br></td></tr><tr><td><br></td><td><br></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"


#  Scenario: A user can adjust the colspans of a table (in an editable region)
    Given the content of the editable region has a table
    And I make a selection

    When I click on the increase colspan editor button
    Then the contents of the editable region should be "this is a <table><tbody><tr><td colspan='2'><span>1</span></td></tr><tr><td><span>3</span></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"

    When I click on the decrease colspan editor button
    Then the contents of the editable region should be "this is a <table><tbody><tr><td><span>1</span></td><td><br></td></tr><tr><td><span>3</span></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"


#  Scenario: A user can adjust the rowspans of a table (in an editable region)
    Given the content of the editable region has a table
    And I make a selection

    When I click on the increase rowspan editor button
    Then the contents of the editable region should be "this is a <table><tbody><tr><td rowspan='2'><span>1</span></td><td><span>2</span></td></tr><tr><td><span>4</span></td></tr></tbody></table> <b>content</b>"

    When I click on the decrease rowspan editor button
    Then the contents of the editable region should be "this is a <table><tbody><tr><td><span>1</span></td><td><span>2</span></td></tr><tr><td><br></td><td><span>4</span></td></tr></tbody></table> <b>content</b>"
