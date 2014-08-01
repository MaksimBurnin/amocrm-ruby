module Amocrm
  class BaseResource
    @@attributes = {}

    def initialize
      @new_record   = true
      @synchronized = false
      @api          = nil
      @values       = {}
    end

    def new_record?
      @new_record
    end

    def find id
      result = @api.send(api_list_method,{id:id})
      if result
        #result[api_]
      end
    end

    def for_json
      result = (@@attributes.map do |key,attr|
        value = @values[key]
        if value.respond_to? :for_json
          value = value.for_json
        end
        [key,value]
      end)

      Hash[result]
    end

    protected

    def self.create_attribute name, kind, default = nil
      name = name.to_sym
      @@attributes[name] = {
        name:    name,
        default: default,
        kind:    kind
      }

      #defining custom getter
      define_method(name) do
        get_attribute name
      end

      define_method("#{name.to_s}=") do |value|
        set_attribute name,value
      end

    end

    def get_attribute name
      @values[name.to_sym] || @@attributes[name.to_sym][:default]
    end

    def set_attribute name, value
      attr = @@attributes[name.to_sym]
      unless value.kind_of? attr[:kind]
        raise ArgumentError.new "#{name} value should have type #{attr[:kind]}, got #{value.class}" 
      end
      @values[name.to_sym] = value
      @synchronized = false
    end
  end
end
