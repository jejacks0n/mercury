Feature:
  As a developer
  In order to keep sane features
  I should be able to run them via rake, cucumber, and rubymine

  @javascript
  Scenario: I can run cucumber features
    When I go to the url: "/edit/test/something"
    Then I should see "/test/something"