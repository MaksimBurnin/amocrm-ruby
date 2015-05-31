require 'yaml'
require 'amocrm'

config_file = "#{File.dirname(__FILE__)}/config.yml"

raise 'spec/config.yml not found, please create one' unless File.exist? config_file
CONFIG = YAML.load_file(config_file)
