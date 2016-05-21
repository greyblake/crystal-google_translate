require "../src/google_translate"

client = GoogleTranslate::Client.new
tr = client.translate("de", "en", "tanzenn")

puts "#{tr.source_lang} -> #{tr.target_lang}"
puts "Query: #{tr.query}"
puts "Corrected query: #{tr.corrected_query}"
puts "Text: #{tr.text}"
tr.variants.each do |word_class, words|
  puts word_class
  words.each do |word|
    puts "  #{word}"
  end
end
