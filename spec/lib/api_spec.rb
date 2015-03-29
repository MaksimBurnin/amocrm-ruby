require 'spec_helper'
require 'pry'

describe Amocrm::API do
  it 'should create an object' do
    api = Amocrm::API.new 'example'
    expect(api).to be_a(Amocrm::API)
  end

  it 'should login' do
    api = Amocrm::API.new CONFIG['subdomain']
    expect(api.auth(CONFIG['login'], CONFIG['hash'])).to be true
    expect { api.exec :post, 'non-existant-method' }.to raise_error(Amocrm::MalformedRequest)
  end

end
