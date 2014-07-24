require 'spec_helper'

describe Amocrm::API do
  it "should create an object" do
    api = Amocrm::API.new 'example'
    expect(api).to be_a(Amocrm::API)
  end
  it "should raise error" do
    api = Amocrm::API.new 'rubygem'
    expect {api.request 'non-existant-method'}.to raise_error(Amocrm::MethodNotFound)
  end
end
