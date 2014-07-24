module Amocrm
  class Error < StandardError; end
  class MethodNotFound < Error; end
  class ServerError < Error; end
  class Unauthorized < Error; end
  class MalformedRequest < Error; end
  class MalformedResponse < Error; end
end
