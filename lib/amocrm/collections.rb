require 'amocrm/collections/base'
Dir.glob("#{File.dirname(__FILE__)}/collections/*.rb").each { |file| require(file) }
