require 'spec_helper'
require 'mol/signature'
require 'digest/md5'

describe MOL::Signature do
  let(:params) do
    {
      x: 2,
      a: 1,
      h: "test",
      m: 123,
      w: "test1"
    }
  end
  let(:sorted_hash) { Hash[params.sort] }

  let(:code) { "123" }
  let(:secret) { "secret" }
  let(:app_name) { "APP" }
  let(:currency) { "PHP" }

  before(:each) do
    MOL.configure do |config|
      config.code = code
      config.secret = secret
      config.currency = currency
      config.app_name = app_name
      config.sandbox_mode = true
    end
  end

  describe "#initialize" do
    specify { expect { MOL::Signature.new }.to raise_error(ArgumentError) }
    specify { expect { MOL::Signature.new("not a hash") }.to raise_error }

    subject { MOL::Signature.new(params) }
    it "should parse the params hash into a alphabetically sorted hash based on key" do
      expect(subject.sorted_hash).to eq sorted_hash
    end
  end

  describe "#digest" do
    subject { MOL::Signature.new(params) }

    it "should return a MD5 digest hash based on the params hash" do
      digest = Digest::MD5.hexdigest(sorted_hash.values.join + MOL.config.secret)
      expect(subject.digest).to eq digest
    end
  end
end
