require 'spec_helper'

describe Quantite do

  context "when is empty" do

    let(:quantite) {Quantite.new}

    it "is empty on creation" do
      expect(quantite.de).to be == 0
    end

    it "has no modeles" do
      quantite.modeles.should be_empty
    end

    it "has no versions" do
      quantite.versions("1").should be_empty
    end

  end

  context "when is set to {1: {2: {XS:2, S:3, M:1, L:0}}}" do
    before :each do
      @quantite.detail.store("1",{"3"=>{"XS"=> 2,"S"=>3,"M"=> 1,"L"=>0}})
      @quantite.detail.store("2",{"4"=>{"XS"=> 5,"S"=>8,"M"=> 4,"L"=>2}})
    end

    it "has two model" do
      @quantite.modeles.should have(2).modele
      @quantite.modeles.should == ["1","2"]
    end

    it "has one version of each modele" do
      @quantite.versions("1").should have(1).version
      @quantite.versions("1").first.should == "3"
      @quantite.versions("2").should have(1).version
      @quantite.versions("2").first.should == "4"
    end

    it "has 25 elements" do
      @quantite.de.should == 25
    end

  end
end
