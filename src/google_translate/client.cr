module GoogleTranslate
  class Client
    # Pretend being Firefox :)
    USER_AGENT = "Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.1.16) Gecko/20110429 Iceweasel/3.5.16 (like Firefox/3.5.1623123)"

    def initialize
      @token_builder = TokenBuilder.new
    end

    def translate(from_lang, to_lang, text)
      sanitized_text = text.gsub(" ", "+")

      headers = HTTP::Headers.new
      headers["User-Agent"] = USER_AGENT

      token = @token_builder.build(text)
      pp token

      url = "https://translate.google.ru/translate_a/single?client=t&sl=#{from_lang}&tl=#{to_lang}&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=#{token}&q=#{sanitized_text}"
      HTTP::Client.get(url, headers)
    end
  end
end
