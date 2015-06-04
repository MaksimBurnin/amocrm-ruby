require 'yaml'
require 'webmock/rspec'
require 'amocrm'

SPEC_ROOT = Pathname.new File.dirname(__FILE__)

Dir[SPEC_ROOT.join("support/**/*.rb")].each { |f| require f }
