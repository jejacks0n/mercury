Feature:
  As a developer
  In order to use image processing within Mercury
  I should be able to use a generator to setup my application

  Scenario: I can install the image processing files required for Mercury
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

  Scenario: I can install the image processing files required for Mercury using Mongoid
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
