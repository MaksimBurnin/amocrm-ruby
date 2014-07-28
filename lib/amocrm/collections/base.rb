module Amocrm
  class BaseCollection < Array
    @@api_obj=nil

    def initialize api_obj=nil
      @api_obj = api_obj if api_obj
      @api_obj ||= @@api_obj
      raise Amocrm::Error.new "No API connection estabilished" unless @api_obj
    end

    def []= value
      check value
      super
    end

    def << value
      check value
      super
    end

    def store
      api.exec set_method, for_json
      
    end

    def get
    end

    def self.record_class
      throw "record_class should be implemented in a subclass"
    end

    protected

    def api
      @api_obj
    end

    def for_json
      for_update = (reject {|res| res.new_record?}).map{|res|res.for_json}
      for_add    = (select {|res| res.new_record?}).map{|res|res.for_json}

      data = {update: for_update, add: for_add}
      request = {request:{}}
      request[:request][json_key]=data
      request
    end

    def check value
      klass = self.class.record_class
      unless value.kind_of? klass
        raise ArgumentError.new "value should have type #{klass}, got #{value.class}" 
      end
    end
  end
end
