require 'spec_helper'
require 'mol/config'

describe MOL::Config do

  describe "#initialize" do
    it "initializes the application" do
      mol = MOL::Config.new
      mol.code.should be
      mol.secret.should be
      mol.app_name.should be
      mol.currency.should eq "MYR"
      mol.sandbox_mode.should be false
    end
  end

  describe "#payout_url" do
    context "when sandbox_mode is true" do
      it "returns the production url" do
        mol = MOL::Config.new
        mol.sandbox_mode = false
        mol.payout_url.should eq "https://api.mol.com/payout/"
      end
    end

    context "when sandbox_mode  is false" do
      it "returns the sandbox url" do
        mol = MOL::Config.new
        mol.sandbox_mode = true
        mol.payout_url.should eq "https://sandbox.api.mol.com/payout/"
      end
    end
  end
end
