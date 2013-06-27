# This file allows you to override various Teaspoon configuration directives when running from the command line. It is
# not required from within the Rails environment, so overriding directives that have been defined within the initializer
# is not possible.
#
# Set RAILS_ROOT and load the environment.
ENV['RAILS_ROOT'] = File.expand_path('..', __FILE__)
load File.expand_path('../../config.ru', __FILE__)
