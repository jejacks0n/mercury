require 'rubygems'
require 'bundler/setup'
require 'action_controller/railtie'
require 'sprockets/railtie'

Bundler.require

module Mercury
  class Application < Rails::Application
    config.session_store :cookie_store, :key => '_app_session'
    config.secret_token = '30dd9731a121fb4a3425fb528ffed853'
    config.active_support.deprecation = :log
    config.consider_all_requests_local = true
    config.encoding = 'utf-8'
    config.eager_load = false

    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.debug = true

    config.assets.paths = []
    config.assets.paths << 'lib/dependencies'
    config.assets.paths << 'lib/javascripts'
    config.assets.paths << 'lib/stylesheets'
    config.assets.paths << 'lib/fonts'

    config.assets.paths << 'uploads'
    config.assets.paths << 'distro'
    config.assets.paths << 'examples/assets'
  end

  Teaspoon.setup do |config|
    config.asset_paths      = ['spec']
    config.fixture_path     = 'spec/fixtures'
    config.coverage_reports = 'text,html,cobertura'

    config.suite do |suite|
      suite.matcher      = 'spec/**/*_spec.{js,js.coffee,coffee}'
      suite.helper       = 'spec_helper'
      suite.javascripts  = ['teaspoon-mocha', 'support/chai', 'support/sinon', 'support/sinon-chai']
      suite.no_coverage << %r(/dependencies|/templates)
    end
  end
end

# ----------------------------------------------------------------------------------------------------
# ! IMPORTANT !
#
# Below this line is not intended as an example and is only used for regression testing / development.
# Please don't do it like this.
#-----------------------------------------------------------------------------------------------------

class ApplicationController < ActionController::Base
  prepend_view_path Rails.application.root.join('examples')

  def page
    render template: params[:page] || 'index'
  end

  def save
    puts params.to_json
    render json: {message: 'saved successfully.'}
  end

  def upload
    path = Rails.root.join('uploads')
    filename = params[:file].original_filename
    FileUtils.mkdir_p(path)
    File.rename(params[:file].tempfile.path, path.join(filename))
    render json: {url: "/assets/#{filename}"}
  end

  def template
    render template: "templates/#{params[:template]}"
  rescue
    render text: "missing template #{params[:template]}"
  end
end

Rails.application.initialize!
Rails.application.routes.draw do
  # rendering pages
  match '/(:page)' => 'application#page', via: :get

  # saving pages
  match '/mercury/save' => 'application#save', via: [:put, :post]

  # rendering server side templates
  match '/mercury/templates/*template' => 'application#template', via: [:get, :post]

  # uploading files
  match '/mercury/uploads' => 'application#upload', via: :post
end

run Mercury::Application rescue nil
