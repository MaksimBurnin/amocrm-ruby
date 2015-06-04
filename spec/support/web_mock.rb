WebMock.disable_net_connect!(allow_localhost: true)

module SharedContext
  extend RSpec::SharedContext

  let(:subdomain) { "fake" }
  let(:valid_login) { "valid@example.com" }
  let(:valid_hash) { "VALIDHASH" }
  let(:api_root) { "https://#{subdomain}.amocrm.ru/private/api" }

  let(:auth_responce) do
    { response: { auth: true } }
  end

  let(:unauth_responce) do
    { response: { auth: false } }
  end

  before(:each) do
    stub_request(:post, "#{api_root}/auth.php?type=json")
      .with(body: hash_including(USER_LOGIN: valid_login, USER_HASH: valid_hash))
      .to_return(status: 200, body: auth_responce.to_json, headers: {"Set-Cookie"=>"session=foobar"})

    stub_request(:post, "#{api_root}/auth.php?type=json")
      .with(body: hash_including(USER_LOGIN: valid_login+'!', USER_HASH: valid_hash+'!'))
      .to_return(status: 200, body: unauth_responce.to_json)

    stub_request(:post, "#{api_root}/v2/json/non-existant-method")
      .to_return(status: 400, body: "bad request")

    stub_request(:post, "#{api_root}/v2/json/contacts/set")
      .to_return(status: 400, body: "bad request")

  end
end

RSpec.configure do |config|
  config.include SharedContext
end
