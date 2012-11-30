When /^I add Mercury as a gem dependency$/ do
  append_to_file('Gemfile', %{\ngem "mercury-rails", :path => "#{File.expand_path('../../../', __FILE__)}"\n})
end

When "I have created a new rails application" do
  step %{I reset Bundler environment variable}
  step %{I successfully run `bundle exec rails new testapp --skip-bundle`}
  step %{I cd to "testapp"}
  step %{I add Mercury as a gem dependency}
  step %{I run `bundle install --local`}
end

Then /^should have the migration "([^"]*)"$/ do |migration|
  in_current_dir do
    Dir["db/migrate/*_#{migration}"].length.should == 1
  end
end

Then /^should not have the migration "([^"]*)"$/ do |migration|
  in_current_dir do
    Dir["db/migrate/*_#{migration}"].length.should == 0
  end
end
