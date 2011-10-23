@javascript
Feature:
  As a content editor type person
  In order to manage content
  I should be able to insert different types of media

  Background:
    Given I am on an editable page
    And the editor won't prompt when leaving the page

  Scenario: A user can expect all this!


#  Scenario: A user can insert and edit an image
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Media" button
    Then the modal window should be visible
    And I should see "Insert Media (images and videos)" within the modal title

    When I fill in "URL" with "/assets/mercury/temp-logo.png"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <img src='/assets/mercury/temp-logo.png'> <b>content</b>"
    And the modal window should not be visible

    When I make a selection for "img"
    And click on the "Insert Media" button
    Then the "media_image_url" field should contain "/assets/mercury/temp-logo.png"

    When I fill in "URL" with "/assets/mercury/default-snippet.png"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <img src='/assets/mercury/default-snippet.png'> <b>content</b>"


#  Scenario: A user can insert and edit an image with an alignment set
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Media" button
    When I fill in "media_image_url" with "/assets/mercury/temp-logo.png"
    And select "Right" from "Alignment"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <img src='/assets/mercury/temp-logo.png' align='right'> <b>content</b>"

    When I make a selection for "img"
    And click on the "Insert Media" button
    And select "Absolute Middle" from "Alignment"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <img src='/assets/mercury/temp-logo.png' align='absmiddle'> <b>content</b>"


  Scenario: A user can edit an image by double clicking it
    Given the content of the editable region has an image

    When I double click on the first image in the editable region
    Then the modal window should be visible
    And I should see "Insert Media (images and videos)" within the modal title
    And the "media_image_url" field should contain "/assets/mercury/temp-logo.png"

    When I fill in "URL" with "/assets/mercury/default-snippet.png"
    And select "Absolute Middle" from "Alignment"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <img src='/assets/mercury/default-snippet.png' align='absmiddle'> <b>content</b>"


  Scenario: A user can embed and edit a youtube video
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Media" button
    And choose "YouTube Share URL"
    And fill in "YouTube Share URL" with "http://youtu.be/Pny4hoN8eII"
    And fill in "Width" with "400"
    And fill in "Height" with "200"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <iframe allowfullscreen='true' src='http://www.youtube.com/embed/Pny4hoN8eII?wmode=transparent' style='width: 400px; height: 200px;' frameborder='0'></iframe> <b>content</b>"

    When I make a selection for "iframe"
    And click on the "Insert Media" button
    Then the "media_youtube_url" field should contain "http://youtu.be/Pny4hoN8eII"

    When I fill in "YouTube Share URL" with "http://youtu.be/Pny4hoN8eI"
    And fill in "Width" with "500"
    And fill in "Height" with "300"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <iframe allowfullscreen='true' src='http://www.youtube.com/embed/Pny4hoN8eI?wmode=transparent' style='width: 500px; height: 300px;' frameborder='0'></iframe> <b>content</b>"


#  Scenario: A user can embed and edit a vimeo video
    Given the content of the editable region is simple content
    And I make a selection

    When I click on the "Insert Media" button
    And choose "Vimeo URL"
    And fill in "Vimeo URL" with "http://vimeo.com/25708134"
    And fill in "Width" with "400"
    And fill in "Height" with "200"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <iframe src='http://player.vimeo.com/video/25708134?title=1&amp;byline=1&amp;portrait=0&amp;color=ffffff' style='width: 400px; height: 200px;' frameborder='0'></iframe> <b>content</b>"

    When I make a selection for "iframe"
    And click on the "Insert Media" button
    Then the "media_vimeo_url" field should contain "http://vimeo.com/25708134"

    When I fill in "Vimeo URL" with "http://vimeo.com/2570813"
    And fill in "Width" with "500"
    And fill in "Height" with "300"
    And press "Insert Media"
    Then the contents of the editable region should be "this is <iframe src='http://player.vimeo.com/video/2570813?title=1&amp;byline=1&amp;portrait=0&amp;color=ffffff' style='width: 500px; height: 300px;' frameborder='0'></iframe> <b>content</b>"
