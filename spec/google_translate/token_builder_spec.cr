require "../spec_helper"

describe GoogleTranslate::TokenBuilder do
  describe "#build" do
    it "builds valid token" do
      builder = GoogleTranslate::TokenBuilder.new

      builder.build("bonega").should eq "198529.341247"
      builder.build("отличный").should eq "249368.392550"
    end
  end
end
