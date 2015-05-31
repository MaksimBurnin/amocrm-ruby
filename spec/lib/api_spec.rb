require 'spec_helper'

describe Amocrm::API do
  let(:auth_responce) do
    {
      response: { auth: true }
    }
  end

  let(:unauth_responce) do
    {
      response: { auth: false }
    }
  end

  before(:each) do

    stub_request(:post, "https://#{subdomain}.amocrm.ru/private/api/auth.php?type=json")
      .with(body: hash_including(USER_LOGIN: valid_login, USER_HASH: valid_hash))
      .to_return(status: 200, body: auth_responce.to_json, headers: {"Set-Cookie"=>"session=foobar"})

    stub_request(:post, "https://#{subdomain}.amocrm.ru/private/api/auth.php?type=json")
      .with(body: hash_including(USER_LOGIN: valid_login+'!', USER_HASH: valid_hash+'!'))
      .to_return(status: 200, body: unauth_responce.to_json)

    stub_request(:post, "https://#{subdomain}.amocrm.ru/private/api/v2/json/non-existant-method")
      .to_return(status: 400, body: "bad request")
  end

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
