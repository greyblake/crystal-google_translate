require "json"
require "cossack"
require "./google_translate/*"

module GoogleTranslate
  class Error < ::Exception; end

  class ResponseError < Error; end

  class ForbiddenResponseError < ResponseError; end
end
