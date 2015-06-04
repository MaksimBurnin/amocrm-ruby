require 'spec_helper'

describe Amocrm::API do
  it 'should create an object' do
    api = Amocrm::API.new 'example'

    expect(api).to be_a(Amocrm::API)
  end

  it 'should login' do
    api = Amocrm::API.new subdomain

    expect(api.auth(valid_login, valid_hash)).to be true
  end

  it 'should return false for wrong credentials' do
    api = Amocrm::API.new subdomain

    expect(api.auth(valid_login+'!', valid_hash+'!')).to be false
  end

  it 'should raise for wrong method' do
    api = Amocrm::API.new subdomain
    api.auth(valid_login, valid_hash)

    expect { api.exec :post, 'non-existant-method' }
      .to raise_error(Amocrm::MalformedRequest)
  end

  it 'should save cookie' do
    api = Amocrm::API.new subdomain
    api.auth(valid_login, valid_hash)

    cookie = api.instance_variable_get(:@cookie)

    expect(cookie).to be_an Array
    expect(cookie.join).to match "foobar"
  end

end
