require "../spec_helper"

Spec2.describe GoogleTranslate::Client do
  let(connection) { Cossack::TestConnection.new }
  let(client) { GoogleTranslate::Client.new { |cossack| cossack.connection = connection } }

  describe "#translate" do
    context "HTTP status is 200" do
      context "with variants" do
        it "returns instance of Translation" do
          connection.stub_get("https://translate.google.com/translate_a/single?client=t&sl=de&tl=en&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=238306.364956&q=liebenn",
                              {200, fixture("de_en_liebenn")})

          translation = client.translate("de", "en", "liebenn")

          expect(translation.http_response.body).to eq fixture("de_en_liebenn")
          expect(translation.source_lang).to eq "de"
          expect(translation.target_lang).to eq "en"
          expect(translation.query).to eq "liebenn"
          expect(translation.corrected_query).to eq "lieben"
          expect(translation.text).to eq "love"
          expect(translation.variants).to eq({"verb" => ["love", "adore", "make love", "be fond of"]})
        end
      end

      context "without variants" do
        it "returns instance of Translation" do
          connection.stub_get("https://translate.google.com/translate_a/single?client=t&sl=eo&tl=ru&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=997872.592526&q=Ni+amas+ilin",
                              {200, fixture("eo_ru_ni_amas_ilin")})

          translation = client.translate("eo", "ru", "Ni amas ilin")

          expect(translation.http_response.body).to eq fixture("eo_ru_ni_amas_ilin")
          expect(translation.source_lang).to eq "eo"
          expect(translation.target_lang).to eq "ru"
          expect(translation.query).to eq "Ni amas ilin"
          expect(translation.corrected_query).to eq "Ni amas ilin"
          expect(translation.text).to eq "Мы любим их"
          expect(translation.variants.size).to eq 0
        end
      end
    end

    context "HTTP status is 403" do
      it "raises ForbiddenResponseError" do
        connection.stub_get("https://translate.google.com/translate_a/single?client=t&sl=en&tl=ru&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=34895.441137&q=forbidden",
                            {403, "forbidden"})

        expect { client.translate("en", "ru", "forbidden") }.
          to raise_error(GoogleTranslate::ForbiddenResponseError, "Looks like GoogleTranslate has changed its algorithm to calculate tk parameter")
      end
    end

    context "HTTP status is another" do
      it "raises ResponseError" do
        connection.stub_get("https://translate.google.com/translate_a/single?client=t&sl=en&tl=eo&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=335848.208022&q=another",
                            {500, "oops"})

        expect { client.translate("en", "eo", "another") }.
          to raise_error(GoogleTranslate::ResponseError)
      end
    end
  end
end
