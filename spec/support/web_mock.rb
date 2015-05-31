WebMock.disable_net_connect!(allow_localhost: true)

module SharedContext
  extend RSpec::SharedContext

  let(:subdomain) { "fake" }
  let(:valid_login) { "valid@example.com" }
  let(:valid_hash) { "VALIDHASH" }
end

RSpec.configure do |config|
  config.include SharedContext
end
