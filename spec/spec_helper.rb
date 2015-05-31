require 'yaml'
require 'webmock/rspec'
require 'amocrm'

SPEC_ROOT = Pathname.new File.dirname(__FILE__)

Dir[SPEC_ROOT.join("support/**/*.rb")].each { |f| require f }

# AmoCRM API config file

config_file = SPEC_ROOT.join "config.yml"
raise 'spec/config.yml not found, please create one' unless File.exist? config_file
CONFIG = YAML.load_file config_file
