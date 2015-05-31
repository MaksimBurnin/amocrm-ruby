require 'uri'
require 'net/http'

module Amocrm
  class API
    API_DOMAIN        = "%{subdomain}.amocrm.ru"
    API_AUTH_PATH     = "/private/api/auth.php?type=json"
    API_METHOD_PATH   = "/private/api/v2/json/%{action}"

    HTTP_CODES =  {
      301 => Error,
      400 => MalformedRequest,
      401 => Unauthorized,
      403 => Unauthorized,
      404 => MethodNotFound,
      500 => ServerError,
      502 => ServerError,
      503 => ServerError
    }

    def initialize(subdomain)
      @options = { subdomain: subdomain }
      @cookie = []
      @connection = nil
    end

    def auth(username, userhash)
      data = { USER_LOGIN: username, USER_HASH: userhash }
      data = URI.encode_www_form(data)
      path = API_AUTH_PATH

      response = request :post, path, data, 'application/x-www-form-urlencoded'

      response['auth']
    end

    def save(collection)
      raise ArgumentError.new "Collection expected, got #{collection.class}" unless collection.kind_of? BaseCollection

      method   = collection.set_method
      json_key = collection.json_key
      data     = collection.for_json

      result = exec :post, method, data
      result[json_key]['add'].each do |item|
        collection[item['request_id']].id=item['id']
      end

      true
    end

    def exec(method, action, data = {})
      path = API_METHOD_PATH % { action: action }
      data = JSON.generate(data)
      request method, path, data
    end

    private

    def connection
      return @connection if @connection
      @connection = Net::HTTP.new(API_DOMAIN % @options, 443)
      @connection.use_ssl = true
      @connection
    end

    def request(method, path, data, content_type = nil)
      headers = default_headers
      headers['Content-Type'] = content_type if content_type

      response = case method.to_sym
                   when :put, :post  then connection.send(method.to_sym, path, data, headers)
                   when :delete, :get then connection.send(method.to_sym, path, headers)
                 end

      cookie = response.to_hash['set-cookie']
      @cookie = cookie if @cookie.nil? || @cookie.empty?

      code = response.code.to_i
      msg  = response.message

      unless [200,204].include? code
        raise HTTP_CODES[code].new(msg) if HTTP_CODES.keys.include? code
        raise Error.new "Server respond with #{code.to_s}"
      end

      begin
        result = JSON.parse(response.body)['response']
      rescue
        raise MalformedResponse.new 'Response is not a valid JSON'
      end

      raise GenericError.new(response['error']) if response['error']

      result
    end

    def default_headers
      headers = {}
      headers['Cookie']       = @cookie.join '; '
      headers['Content-Type'] = 'application/json'

      headers
    end

  end
end
