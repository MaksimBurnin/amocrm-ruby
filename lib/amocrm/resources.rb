require 'amocrm/resources/base'
Dir.glob("#{File.dirname(__FILE__)}/resources/*.rb").each { |file| require(file) }
