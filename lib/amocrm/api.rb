module Amocrm
  class API
    API_DOMAIN        = "%{subdomain}.amocrm.ru"
    API_AUTH_PATH     = "/private/api/auth.php?type=json"
    API_METHOD_PATH   = "/private/api/v2/json/%{method}"

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

    def initialize subdomain
      @options = { subdomain: subdomain }
      @cookie = []
      @http   = nil
    end

    def auth username, userhash
      data = {'USER_LOGIN' => username, 'USER_HASH' => userhash, 'type'=> 'json'}
      data = URI.encode_www_form(data)
      path = API_AUTH_PATH

      response = request path, data, 'application/x-www-form-urlencoded'

      response['auth']
    end

    def exec method, data = {}
      path = API_METHOD_PATH % {method: method}
      data = JSON.generate(data)
      request path, data, 'application/json'
    end

    private

    def connection
      @http ||= Net::HTTP.new(API_DOMAIN % @options, 443)
      @http.use_ssl = true
    end

    def request path, data, content_type
      connection

      response = @http.post path, data, headers.merge({'Content-Type'=>content_type})
      @cookie = response.to_hash['set-cookie']

      code = response.code.to_i
      msg  = response.message

      unless [200,204].include? code
        raise HTTP_CODES[code].new(msg) if HTTP_CODES.keys.include? code
        raise Error.new "Server respond with #{code.to_s}"
      end

      begin
        result = JSON.parse(response.body)['response']
      rescue
        raise MalformedResponse.new "Responce is not a valid JSON"
      end

      raise GenericError.new(response['error']) if response['error']

      result
    end

    def headers
      {
        'Cookie'           => @cookie.join,
        #'Content-Type'     => 'application/json',
        'User-Agent'       => 'amocrm-gem-ruby/'+VERSION,
        'X-Human-Greeting' => 'Preved Medved'
      }
    end

    def path method

    end

  end
end
