@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to insert links of different types

  Background:
    Given I am on an editable page
    And the editor won't prompt when leaving the page

  Scenario: A user can expect all this!


#  Scenario: A user can insert and edit a link to an external site
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Link" button
    Then the modal window should be visible
    And the "Link Content" field should contain "simple"

    When I fill in "URL" with "http://google.com"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a href='http://google.com'>simple</a> <b>content</b>"
    And the modal window should not be visible

    When I click on the "Insert Link" button
    Then I should not see "Link Content"

    When I fill in "URL" with "http://cnn.com"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a href='http://cnn.com'>simple</a> <b>content</b>"


#  Scenario: A user can insert and edit a link with a target set
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Link" button
    And fill in "URL" with "http://google.com"
    And select "Blank (a new window or tab)" from "Link Target"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a target='_blank' href='http://google.com'>simple</a> <b>content</b>"

    When I click on the "Insert Link" button
    And select "Top (removes any frames)" from "Link Target"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a target='_top' href='http://google.com'>simple</a> <b>content</b>"


#  Scenario: A user can insert a link to an external site and open it in a popup
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Link" button
    And fill in "URL" with "http://google.com"
    And select "Popup Window (javascript new window popup)" from "Link Target"
    And I fill in "Popup Width" with "500"
    And fill in "Popup Height" with "200"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a href='javascript:void(window.open('http://google.com', 'popup_window', 'width=500,height=200,menubar=no,toolbar=no'))'>simple</a> <b>content</b>"

    When I click on the "Insert Link" button
    Then the "Popup Width" field should contain "500"
    And the "Popup Height" field should contain "200"


#  Scenario: A user can insert a bookmark and then link to it
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Link" button
    And I choose "Bookmark"
    And fill in "Bookmark" with "test-bookmark1"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a name='test-bookmark1'>simple</a> <b>content</b>"

    When I make a selection for "b"
    And click on the "Insert Link" button
    And I choose "Existing Links"
    And select "simple" from "Existing Links"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a name='test-bookmark1'>simple</a> <a href='#test-bookmark1'>content</a>"

    When I make a selection for "a"
    And click on the "Insert Link" button
    # todo: this should prefill
    #Then the "Bookmark" field should contain "test-bookmark1"
    And I choose "Bookmark"
    And fill in "Bookmark" with "test-bookmark2"
    And press "Insert Link"
    Then the contents of the editable region should be "this is <a name='test-bookmark2'>simple</a> <a href='#test-bookmark1'>content</a>"

    # todo: when I change the name of a bookmark, and bookmarks that are pointing to me should also be updated (on this page)


  Scenario: A user can navigate links inside of regions
    # todo: finish