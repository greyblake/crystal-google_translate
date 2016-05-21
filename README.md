# Crystal GoogleTranslate [![Build Status](https://travis-ci.org/greyblake/crystal-google_translate.svg?branch=master)](https://travis-ci.org/greyblake/crystal-google_translate)

Crystal client for GoogleTranslate

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  google_translate:
    github: greyblake/crystal-google_translate
```


## Usage

```crystal
require "google_translate"
```

### Example
The following code translates german word `tanzen` with a typo(double n) and prints the result:


```crystal
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
```

Output:

```
de -> en
Query: tanzenn
Corrected query: tanzen
Text: dance
verb
  dance
  hop
  spin
  bob
  foot
```


## Development

To run specs:

```
crystal spec
```

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer
