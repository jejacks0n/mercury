@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to manipulate it in various ways (eg. bold, add italics, set headers, colors, etc.)

  Background:
    Given I am on an editable page
    And the editor won't prompt when leaving the page

  Scenario: A user can expect all this!


#  Scenario: A user can set and unset bold content
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the bold editor button
    Then the contents of the editable region should be "this is <b><span>simple</span></b> <b>content</b>"

    When I click on the bold editor button
    Then the contents of the editable region should be "this is <span>simple</span> <b>content</b>"


#  Scenario: A user can italicize content
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the italicize editor button
    Then the contents of the editable region should be "this is <i><span>simple</span></i> <b>content</b>"

    When I click on the italicize editor button
    Then the contents of the editable region should be "this is <span>simple</span> <b>content</b>"


#  Scenario: A user can overline content
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the overline editor button
    Then the contents of the editable region should be "this is <span style='text-decoration:overline'><span>simple</span></span> <b>content</b>"
    # doesn't remove overlines


#  Scenario: A user can strikeout content
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the strikethrough editor button
    Then the contents of the editable region should be "this is <strike><span>simple</span></strike> <b>content</b>"

    When I click on the strikethrough editor button
    Then the contents of the editable region should be "this is <span>simple</span> <b>content</b>"

#  Scenario: A user can underline content
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the underline editor button
    Then the contents of the editable region should be "this is <u><span>simple</span></u> <b>content</b>"

    When I click on the underline editor button
    Then the contents of the editable region should be "this is <span>simple</span> <b>content</b>"


#  Scenario: A user can make content superscript
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the superscript editor button
    Then the contents of the editable region should be "this is <sup><span>simple</span></sup> <b>content</b>"

    When I click on the superscript editor button
    Then the contents of the editable region should be "this is <span>simple</span> <b>content</b>"


#  Scenario: A user can make content subscript
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the subscript editor button
    Then the contents of the editable region should be "this is <sub><span>simple</span></sub> <b>content</b>"

    When I click on the subscript editor button
    Then the contents of the editable region should be "this is <span>simple</span> <b>content</b>"


#  Scenario: A user can justify content to the left, center, right, or fully justified
    # firefox: this isn't possible on the first line due to a bug in gecko, so we have special content for it
    Given the content of the editable region has justifiable content
    And I make a selection

    When I click on the justify left editor button
    Then the contents of the editable region should be "<div>first line</div><br><div align='left'>this is <span>justifiable</span> <b>content</b></div>"

    When I click on the justify center editor button
    Then the contents of the editable region should be "<div>first line</div><br><div align='center'>this is <span>justifiable</span> <b>content</b></div>"

    When I click on the justify right editor button
    Then the contents of the editable region should be "<div>first line</div><br><div align='right'>this is <span>justifiable</span> <b>content</b></div>"

    When I click on the full justification editor button
    Then the contents of the editable region should be "<div>first line</div><br><div align='justify'>this is <span>justifiable</span> <b>content</b></div>"


#  Scenario: A user can make an unordered list
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the insert unordered list editor button
    Then the contents of the editable region should be "<ul><li>this is <span>simple</span> <b>content</b></li></ul>"

    # todo: we should test enter and tab, and shift+tab in advanced editing

#  Scenario: A user can make an ordered list
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the insert ordered list editor button
    Then the contents of the editable region should be "<ol><li>this is <span>simple</span> <b>content</b></li></ol>"

    # todo: we should test enter and tab, and shift+tab in advanced editing


#  Scenario: A user can indent and outdent content
    # firefox: this isn't possible on the first line due to a bug in gecko, so we have special content for it
    Given the content of the editable region has justifiable content
    And I make a selection

    When I click on the indent editor button
    Then the contents of the editable region should be "<div>first line</div><br><blockquote>this is <span>justifiable</span> <b>content</b></blockquote>"

    When I click on the indent editor button
    Then the contents of the editable region should be "<div>first line</div><br><blockquote><blockquote>this is <span>justifiable</span> <b>content</b></blockquote></blockquote>"

    When I click on the outdent editor button
    Then the contents of the editable region should be "<div>first line</div><br><blockquote>this is <span>justifiable</span> <b>content</b></blockquote>"

    When I click on the outdent editor button
    Then the contents of the editable region should be "<div>first line</div><br>this is <span>justifiable</span> <b>content</b>"


#  Scenario: A user can insert horizontal rules
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the insert hr editor button
    Then the contents of the editable region should be "this is&nbsp;<hr size='2' width='100%'> <b>content</b>"

    When I click on the insert hr editor button
    Then the contents of the editable region should be "this is&nbsp;<hr size='2' width='100%'><hr size='2' width='100%'> <b>content</b>"


#  Scenario: A user can clean/remove formatting on their selection
    Given the content of the editable region has wrapped content
    And I make a selection

    When I click on the remove formatting editor button
    Then the contents of the editable region should be "this is wrapped content"


#  Scenario: A user can wrap content within predefined styles
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the style editor dropdown
    And select the red style from the dropdown
    Then the contents of the editable region should be "this is <span class='red'><span>simple</span></span> <b>content</b>"


#  Scenario: A user can wrap content in formatted block tags
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the block format editor dropdown
    And select the heading 2 block from the dropdown
    Then the contents of the editable region should be "<h2>this is <span>simple</span> <b>content</b></h2>"


#  Scenario: A user can set the background color of a selection
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the background color editor palette
    And click on the color red
    Then the contents of the editable region should be "this is <span style='background-color:#FF0000'><span>simple</span></span> <b>content</b>"


#  Scenario: A user can set the foreground color
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the foreground color editor palette
    And click on the color red
    Then the contents of the editable region should be "this is <font color='rgb(255, 0, 0)'><span>simple</span></font> <b>content</b>"
