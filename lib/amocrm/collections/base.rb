module Amocrm
  class BaseCollection
    include Enumerable

    @@req_id  = 1
    @@api_obj = nil

    def initialize
      @resources = []
    end

    def []= index, value
      check value
      req_id = (@@req_id += 1)

      value.request_id = req_id
      @resources[req_id] = value
    end

    def << value
      check value
      value.request_id = (@@req_id += 1)
      @resources << value
    end

    def [] index
      @resources[index]
    end

    def each &block
      @resources.each(&block)
    end

    def self.record_class
      throw "record_class should be implemented in a subclass"
    end

    def request_item request_id
      detect{|i|i.request_id = request_id}
    end

    def for_json
      items      = @resources
      for_update = (items.reject{|res| res.new_record?}).map{|res|res.for_json}
      for_add    = (items.select{|res| res.new_record?}).map{|res|res.for_json}

      data = {update: for_update, add: for_add}
      request = {request:{}}
      request[:request][json_key]=data
      request
    end

    protected

    def check value
      klass = self.class.record_class
      unless value.kind_of? klass
        raise ArgumentError.new "value should have type #{klass}, got #{value.class}" 
      end
    end
  end
end
