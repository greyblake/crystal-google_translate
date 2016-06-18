require "../spec_helper"

Spec2.describe GoogleTranslate::TokenBuilder do
  describe "#build" do
    it "builds valid token" do
      builder = GoogleTranslate::TokenBuilder.new

      expect(builder.build("bonega")).to eq "198529.341247"
      expect(builder.build("отличный")).to eq "249368.392550"
    end
  end
end
