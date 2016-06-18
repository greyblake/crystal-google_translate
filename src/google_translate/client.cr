module GoogleTranslate
  class Client
    # Pretend being Firefox :)
    USER_AGENT = "Mozilla/5.0 (X11; U; Linux x86_64; en; rv:1.9.1.16) Gecko/20110429 Iceweasel/3.5.16 (like Firefox/3.5.1623123)"

    BASE_URL = "https://translate.google.com"

    def initialize
      @token_builder = TokenBuilder.new
      @cossack = Cossack::Client.new(BASE_URL)
      @cossack.headers["User-Agent"] = USER_AGENT
      yield @cossack
    end

    def initialize
      @token_builder = TokenBuilder.new
      @cossack = Cossack::Client.new(BASE_URL)
      @cossack.headers["User-Agent"] = USER_AGENT
    end

    def translate(source_lang : String, target_lang : String, query : String) : Translation
      http_response = raw_translate(source_lang, target_lang, query)
      normalized_data = http_response.body.gsub(/,+/, ",").gsub("[,", "[")
      parsed_data = JSON.parse(normalized_data)

      main_info = parsed_data[0][0]
      translated_text = main_info[0].as_s
      corrected_source_text = main_info[1].as_s

      translation = Translation.new(http_response, source_lang, target_lang, query, corrected_source_text, translated_text)

      # If variants of translation are present, parse them
      if parsed_data[1]? && parsed_data[1].as_a?
        parsed_data[1].each do |tr|
          word_class = tr[0].as_s
          words = tr[1].as_a.map(&.to_s)
          translation.variants[word_class] = words
        end
      end

      translation
    end

    private def raw_translate(source_lang : String, target_lang : String, query : String)
      sanitized_query = query.gsub(" ", "+")
      token = @token_builder.build(query)
      path = "/translate_a/single?client=t&sl=#{source_lang}&tl=#{target_lang}&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=#{token}&q=#{sanitized_query}"

      http_response = @cossack.get(path)

      case http_response.status
      when 200
        http_response
      when 403
        raise ForbiddenResponseError.new("Looks like GoogleTranslate has changed its algorithm to calculate tk parameter")
      else
        raise ResponseError.new("Response HTTP status: #{http_response.status} (expected 200)")
      end
    end
  end
end
