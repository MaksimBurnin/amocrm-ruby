module Amocrm
  class Contacts < BaseCollection

    def self.record_class
      Amocrm::Contact
    end

    def json_key
      "contacts"
    end

    def list_method
      "contacts/list"
    end

    def set_method
      "contacts/set"
    end

  end
end
