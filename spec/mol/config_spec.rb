require 'spec_helper'
require 'mol/config'

describe MOL::Config do

  describe "#initialize" do
    it "should initialize the application" do
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
      it "should return the production url" do
        mol = MOL::Config.new
        mol.sandbox_mode = false
        mol.payout_url.should eq "https://api.mol.com/payout"
      end
    end

    context "when sandbox_mode  is false" do
      it "should return the sandbox url" do
        mol = MOL::Config.new
        mol.sandbox_mode = true
        mol.payout_url.should eq "https://sandbox.api.mol.com/payout"
      end
    end
  end
end
