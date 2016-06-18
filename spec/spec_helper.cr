require "spec2"

require "../src/google_translate"

FIXTURES_PATH = File.expand_path("../fixtures", __FILE__)

def fixture(name)
  file_name = File.join(FIXTURES_PATH, "#{name}.txt")
  File.read(file_name)
end
