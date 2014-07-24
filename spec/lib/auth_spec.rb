require 'spec_helper'

describe Amocrm::API do
  it "should login" do
    api = Amocrm::API.new 'rubygem'
    expect(api.auth(CONFIG['login'],CONFIG['hash'])).to be true
  end
end
