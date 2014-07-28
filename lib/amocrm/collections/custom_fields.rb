module Amocrm
  class CustomFields < BaseCollection

    def self.record_class
      Amocrm::CustomField
    end

  end
end
