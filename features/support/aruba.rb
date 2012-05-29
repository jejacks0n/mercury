BUNDLE_ENV_VARS = %w(RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE)
ORIGINAL_BUNDLE_VARS = Hash[ENV.select{ |key,value| BUNDLE_ENV_VARS.include?(key) }]

Before do
  if ! ENV['BUNDLE_GEMFILE'].include?(Dir.pwd)
    ENV['BUNDLE_GEMFILE'] = File.join(Dir.pwd, ENV['BUNDLE_GEMFILE'])
  end
end

After do
  ORIGINAL_BUNDLE_VARS.each_pair do |key, value|
    ENV[key] = value
  end
end

When /^I reset Bundler environment variable$/ do
  BUNDLE_ENV_VARS.each do |key|
    ENV[key] = nil
  end
end

Before do
  @aruba_timeout_seconds = 20
end

Before('@slow') do
  @aruba_timeout_seconds = 180
end
