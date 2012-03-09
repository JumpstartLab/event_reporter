require 'rubygems'
require 'bundler'
Bundler.setup

#require 'aruba/api'

#Dir['./spec/support/*.rb'].map {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true
  #config.include Aruba::Api, :example_group => {
  #    :file_path => /spec\/integration/
  #}
end
