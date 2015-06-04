require 'yaml'
require 'webmock/rspec'
require 'amocrm'

Dir[ File.dirname(__FILE__)+"/support/**/*.rb" ].each { |f| require f }
