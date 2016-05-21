module GoogleTranslate
  # Represents GoogleTranslate parsed response.
  class Translation
    getter :http_response
    getter :source_lang, :target_lang, :query, :corrected_query, :text, :variants

    def initialize(@http_response : HTTP::Client::Response, @source_lang : String, @target_lang : String, @query : String, @corrected_query : String, @text : String)
      @variants = {} of String => Array(String)
    end
  end
end
