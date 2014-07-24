module Amocrm
  class API
    API_DOMAIN = "%{subdomain}.amocrm.ru"
    API_PATH   = "/private/api/%{method}.php?type=json"

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

    def request method, data = {}
      connection

      header = headers
      if data.kind_of? Hash
        header['Content-Type'] = 'application/json'
        data = JSON.generate(data)
      else
        header['Content-Type'] ='application/x-www-form-urlencoded'
      end

      response = @http.post path(method), data, header
      code = response.code.to_i
      msg  = response.message

      unless [200,204].include? code
        raise HTTP_CODES[code].new(msg) if HTTP_CODES.keys.include? code
        raise Error.new "Server respond with #{code.to_s}"
      end

      @cookie = response.to_hash['set-cookie']

      begin
        result = JSON.parse(response.body)['response']
      rescue
        raise MalformedResponse.new "Responce is not a valid JSON"
      end

      raise GenericError.new(response['error']) if response['error']

      result
    end

    private
    def connection
      @http ||= Net::HTTP.new(API_DOMAIN % @options, 443)
      @http.use_ssl = true
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
      API_PATH % {method: method}
    end
  end
end
