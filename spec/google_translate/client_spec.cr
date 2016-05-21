require "../spec_helper"

describe GoogleTranslate::Client do
  describe "#translate" do
    context "HTTP status is 200" do
      context "with variants" do
        it "returns instance of Translation" do
          WebMock.stub(:get, "translate.google.com/translate_a/single?client=t&sl=de&tl=en&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=238306.364956&q=liebenn")
            .to_return(body: fixture("de_en_liebenn"))

          client = GoogleTranslate::Client.new
          translation = client.translate("de", "en", "liebenn")

          translation.http_response.body.should eq fixture("de_en_liebenn")
          translation.source_lang.should eq "de"
          translation.target_lang.should eq "en"
          translation.query.should eq "liebenn"
          translation.corrected_query.should eq "lieben"
          translation.text.should eq "love"
          translation.variants.should eq({"verb" => ["love", "adore", "make love", "be fond of"]})
        end
      end

      context "without variants" do
        it "returns instance of Translation" do
          WebMock.stub(:get, "translate.google.com/translate_a/single?client=t&sl=eo&tl=ru&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=997872.592526&q=Ni+amas+ilin")
            .to_return(body: fixture("eo_ru_ni_amas_ilin"))

          client = GoogleTranslate::Client.new
          translation = client.translate("eo", "ru", "Ni amas ilin")

          translation.http_response.body.should eq fixture("eo_ru_ni_amas_ilin")
          translation.source_lang.should eq "eo"
          translation.target_lang.should eq "ru"
          translation.query.should eq "Ni amas ilin"
          translation.corrected_query.should eq "Ni amas ilin"
          translation.text.should eq "Мы любим их"
          translation.variants.size.should eq 0
        end
      end
    end

    context "HTTP status is 403" do
      it "raises ForbiddenResponseError" do
        WebMock.stub(:get, "translate.google.com/translate_a/single?client=t&sl=en&tl=ru&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=34895.441137&q=forbidden")
          .to_return(body: "forbidden", status: 403)

        client = GoogleTranslate::Client.new

        expect_raises(GoogleTranslate::ForbiddenResponseError, "Looks like GoogleTranslate has changed its algorithm to calculate tk parameter") do
          client.translate("en", "ru", "forbidden")
        end
      end
    end

    context "HTTP status is another" do
      it "raises ResponseError" do
        WebMock.stub(:get, "translate.google.com/translate_a/single?client=t&sl=en&tl=eo&hl=en&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=1&rom=0&ssel=0&tsel=0&kc=7&tk=335848.208022&q=another").to_return(body: "oops", status: 500)

        client = GoogleTranslate::Client.new

        expect_raises(GoogleTranslate::ResponseError) do
          client.translate("en", "eo", "another")
        end
      end
    end
  end
end
