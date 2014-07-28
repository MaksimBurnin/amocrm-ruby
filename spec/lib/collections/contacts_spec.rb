require 'spec_helper'

describe Amocrm::Contact do
  def api
    amo = Amocrm::API.new CONFIG['subdomain']
    amo.auth(CONFIG['login'],CONFIG['hash'])
    amo
  end

  it "Should reject values of different types" do
    list = Amocrm::Contacts.new api
    expect{list << "Some Value"}.to raise_error ArgumentError
  end

  it "Should save contacts" do

    list = Amocrm::Contacts.new api
    contact = Amocrm::Contact.new
    contact.name = 'Fedor sergeevich'
    contact.type = 'contact'
    list << contact
    expect(list.store).to eq true
  end
end
