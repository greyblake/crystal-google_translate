require "../src/google_translate"

client = GoogleTranslate::Client.new
http_response = client.translate("ru", "en", "отличный")
pp http_response.status_code
pp http_response.body[0..100]

puts
http_response = client.translate("eo", "ru", "bonega")
pp http_response.status_code
pp http_response.body[0..100]
