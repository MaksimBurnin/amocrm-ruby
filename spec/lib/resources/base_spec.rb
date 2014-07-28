require 'spec_helper'

describe Amocrm::BaseResource do

  class TestResource < Amocrm::BaseResource
    create_attribute :int, Integer, 100
  end

  it "should create attributes" do
    resource = TestResource.new

    expect(resource.int).to eq(100)

    resource.int = 0
    expect(resource.int).to eq(0)

    expect{resource.int = "test"}.to raise_error
  end

  it "should create encode to json" do
    resource = TestResource.new
    resource.int = 123
    json = JSON.generate(resource.for_json)
    hash = JSON.parse(json)
    expect(hash['int']).to eq 123
  end
end
