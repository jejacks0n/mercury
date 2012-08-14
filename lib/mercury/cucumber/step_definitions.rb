require 'xpath'

World(ActionController::RecordIdentifier)

# require support files
Dir[File.join(File.dirname(__FILE__), 'support', '*')].each do |file|
  require file
end

# require the common step defintions
Dir[File.join(File.dirname(__FILE__), 'step_definitions', '*')].each do |file|
  require file
end
