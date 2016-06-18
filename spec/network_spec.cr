require "./spec_helper"

Spec2.describe "Network request" do
  it "gets translation from GoogleTranslate" do
    client = GoogleTranslate::Client.new
    translation = client.translate("de", "en", "lieben")

    expect(translation.http_response.status).to eq 200
    expect(translation.source_lang).to eq "de"
    expect(translation.target_lang).to eq "en"
    expect(translation.query).to eq "lieben"
    expect(translation.corrected_query).to eq "lieben"
    expect(translation.variants).to eq({"verb" => ["love", "adore", "make love", "be fond of"]})
    expect(translation.text).to eq "love"
  end
end
