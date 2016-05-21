require "./spec_helper"

describe "Network request" do
  it "gets translation from GoogleTranslate" do
    WebMock.allow_net_connect = true

    client = GoogleTranslate::Client.new
    translation = client.translate("de", "en", "lieben")

    translation.http_response.status_code.should eq 200
    translation.source_lang.should eq "de"
    translation.target_lang.should eq "en"
    translation.query.should eq "lieben"
    translation.corrected_query.should eq "lieben"
    translation.text.should eq "love"
    translation.variants.should eq({"verb" => ["love", "adore", "make love", "be fond of"]})


    WebMock.allow_net_connect = false
  end
end
