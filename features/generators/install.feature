# @announce
Feature:
  As a developer
  In order to use mercury
  I should be able to use a generator to setup my application


  Scenario: A developer I want a basic install of mercury
    Given I have created a new rails application
    When I run `bundle exec rails generate mercury:install --trace` interactively
    And I type "N"
    And I type "N"
    Then the following files should exist:
      | app/assets/javascripts/mercury.js             |
    And the file "config/routes.rb" should contain "mount Mercury::Engine => '/'"

  Scenario: A developer I want a full install of mercury
    Given I have created a new rails application
    When I successfully run `bundle exec rails generate mercury:install --full --trace`
    Then the following files should exist:
      | app/assets/javascripts/mercury.js             |
      | app/assets/stylesheets/mercury_overrides.css  |
      | app/views/layouts/mercury.html.erb            |
      | lib/mercury/authentication.rb                 |
    And the file "config/routes.rb" should contain "mount Mercury::Engine => '/'"

  Scenario: A developer I want to install the image backend for Mercury
    Given I have created a new rails application
    When I successfully run `bundle exec rails generate mercury:install:images --trace`
    Then the following files should exist:
      | app/controllers/mercury/images_controller.rb |
      | app/models/mercury/image.rb |
    And the file "app/models/mercury/image.rb" should contain "class Mercury::Image < ActiveRecord::Base"
    And should have the migration "create_mercury_images.rb"
    And the file "config/routes.rb" should contain:
      """
          namespace :mercury do
            resources :images
          end
      """
    And the file "Gemfile" should contain "gem 'paperclip'"

  Scenario: A developer I want to install the image backend for Mercury with Mongoid
    Given I have created a new rails application
    When I successfully run `bundle exec rails generate mercury:install:images --orm mongoid --trace`
    Then the following files should exist:
      | app/controllers/mercury/images_controller.rb |
      | app/models/mercury/image.rb |
    And the file "app/models/mercury/image.rb" should contain:
    """
    class Mercury::Image
      include Mongoid::Document
      include Mongoid::Paperclip
    """
    And should not have the migration "create_mercury_images.rb"
    And the file "config/routes.rb" should contain:
      """
          namespace :mercury do
            resources :images
          end
      """
    And the file "Gemfile" should contain "gem 'paperclip'"

