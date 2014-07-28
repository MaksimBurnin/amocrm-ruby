require 'spec_helper'

describe Amocrm::Contact do
  it "Should have attributes according to API description" do
    resource = Amocrm::Contact.new
    expect(resource).to respond_to(:company_name)
    expect(resource).to respond_to(:type)
    expect(resource).to respond_to(:server_time)
    expect(resource).to respond_to(:created_user_id)
    expect(resource).to respond_to(:linked_lead_id)
    expect(resource).to respond_to(:tags)
    expect(resource).to respond_to(:custom_fields)
  end

  it "Should be able to prepare for json" do
    resource = Amocrm::Contact.new
    resource.company_name = "Google"
    expect(resource.for_json[:company_name]).to eq 'Google'
  end
end
