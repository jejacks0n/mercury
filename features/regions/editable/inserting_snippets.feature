@javascript
Feature:
  As a content editor type person
  In order to reuse content chunks
  I should be able to put snippets into regions

  Background:
    Given I am on an editable page
    And the editor won't prompt when leaving the page

  Scenario: A user can expect all this!


  # todo: these can't be one scenario because snippet.load doesn't find/replace existing ones
  Scenario: A user can drag and drop snippets into an editable region
    Given the content of the editable region is simple content
    And I make a selection

    When I open the snippet panel
    And I drag the example snippet into the editable region
    Then the modal window should be visible
    And I should see "Snippet Options" within the modal title

    When I fill in "First Name" with "Jeremy"
    And fill in "Favorite Beer" with "Stella"
    And press "Insert Snippet"
    Then the modal window should not be visible
    And the contents of the editable region should be "this is <div data-version='1' data-snippet='snippet_14' class='mercury-snippet' contenteditable='false'><strong>Jeremy</strong> likes Stella</div><span>simple</span> <b>content</b>"


  Scenario: A user can use the snippet toolbar to remove a snippet
    Given the options for the example snippet "snippet_42" are first_name: "Jeremy", favorite_beer: "Stella"
    And the content of the editable region has that snippet

    When I hover over the snippet
    Then the snippet toolbar should be visible

    When I click on the remove snippet toolbar button
    Then the contents of the editable region should be " <b>content</b>"


  Scenario: A user can use the snippet toolbar to edit the options of a snippet
    Given the options for the example snippet "snippet_42" are first_name: "Hipsters", favorite_beer: "PBR"
    And the content of the editable region has that snippet

    When I hover over the snippet
    And click on the edit snippet settings toolbar button
    Then the modal window should be visible
    And the "First Name" field should contain "Hipsters"
    And the "Favorite Beer" field should contain "PBR"

    When I fill in "First Name" with "Jeremy"
    And fill in "Favorite Beer" with "Stella"
    And press "Insert Snippet"
    Then the contents of the editable region should be "<div data-version='2' data-snippet='snippet_42' class='mercury-snippet' contenteditable='false'><strong>Jeremy</strong> likes Stella</div> <b>content</b>"


  Scenario: A user can make changes to a snippets options, and they'll be versioned for undo and redo
    Given the options for the example snippet "snippet_42" are first_name: "Hipsters", favorite_beer: "PBR"
    And the content of the editable region has that snippet

    When I edit the snippet
    And I fill in "First Name" with "Jeremy"
    And fill in "Favorite Beer" with "Stella"
    And press "Insert Snippet"
    Then the contents of the editable region should be "<div data-version='2' data-snippet='snippet_42' class='mercury-snippet' contenteditable='false'><strong>Jeremy</strong> likes Stella</div> <b>content</b>"

    When I edit the snippet
    Then the "First Name" field should contain "Jeremy"
    And the "Favorite Beer" field should contain "Stella"

    When fill in "First Name" with "Diesel"
    And fill in "Favorite Beer" with "Bells Hopslam"
    And press "Insert Snippet"
    Then the content of the editable region should be "<div data-version='3' data-snippet='snippet_42' class='mercury-snippet' contenteditable='false'><strong>Diesel</strong> likes Bells Hopslam</div> <b>content</b>"

    When I click on the "Undo" button
    Then the contents of the editable region should be "<div data-version='2' data-snippet='snippet_42' class='mercury-snippet' contenteditable='false'><strong>Jeremy</strong> likes Stella</div> <b>content</b>"

    When I edit the snippet
    # todo: this is a bug
#    Then the "First Name" field should contain "Jeremy"
#    And the "Favorite Beer" field should contain "Stella"

    When I close the modal
    When I click on the "Redo" button
    Then the contents of the editable region should be "<div data-version='3' data-snippet='snippet_42' class='mercury-snippet' contenteditable='false'><strong>Diesel</strong> likes Bells Hopslam</div> <b>content</b>"

    When I edit the snippet
    Then the "First Name" field should contain "Diesel"
    And the "Favorite Beer" field should contain "Bells Hopslam"

    When I fill in "First Name" with "Jen"
    And fill in "Favorite Beer" with "Miller High Life"
    And press "Insert Snippet"
    Then the contents of the editable region should be "<div data-version='4' data-snippet='snippet_42' class='mercury-snippet' contenteditable='false'><strong>Jen</strong> likes Miller High Life</div> <b>content</b>"


  Scenario: When a user saves, the snippets should be gone from the html, but the options are serialized
    Given the options for the example snippet "snippet_42" are first_name: "Hipsters", favorite_beer: "PBR"
    And the content of the editable region has that snippet

    When I click on the "Save" button
