require 'yaml'
require 'webmock/rspec'
require 'amocrm'

Dir[SPEC_ROOT.join("support/**/*.rb")].each { |f| require f }
