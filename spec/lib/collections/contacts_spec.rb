require 'spec_helper'

describe Amocrm::Contacts do
  it 'Should reject values of different types' do
    list = Amocrm::Contacts.new
    expect{list << 'Some Value'}.to raise_error ArgumentError
  end

  it 'Should save contacts' do
    amo = Amocrm::API.new subdomain
    amo.auth(valid_login, valid_hash)

    name = 'Fedor sergeevich'
    list = Amocrm::Contacts.new
    contact = Amocrm::Contact.new
    contact.name = 'Fedor sergeevich'
    contact.type = 'contact'
    list << contact
    expect(amo.save list).to eq true
    expect(contact.id).to be > 0
    expect(contact.name).to eq name
  end
end
