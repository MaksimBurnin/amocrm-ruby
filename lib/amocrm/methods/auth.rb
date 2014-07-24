module Amocrm
  class API
    def auth username, userhash
      data = {'USER_LOGIN' => username, 'USER_HASH' => userhash, 'type'=> 'json'}

      response = request 'auth', URI.encode_www_form(data)
      response['auth'] == true
    end
  end
end
