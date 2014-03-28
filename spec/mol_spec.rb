require 'spec_helper'
require 'mol'

describe MOL do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end

  context "when MOL::Config is called" do
    specify { expect(MOL::Config).to eq MOL::Config }
    specify { expect { MOL::Config }.not_to raise_error }
    specify { expect(MOL::Config).to be_truthy }
  end

  context "when MOL::Client is called" do
    specify { expect(MOL::Client).to eq MOL::Client }
    specify { expect { MOL::Client }.not_to raise_error }
    specify { expect(MOL::Client).to be_truthy }
  end

  context "when MOL::Signature is called" do
    specify { expect(MOL::Signature).to eq MOL::Signature }
    specify { expect { MOL::Signature }.not_to raise_error }
    specify { expect(MOL::Signature).to be_truthy }
  end

  describe ".config" do
    specify { expect(MOL.config).to be_a MOL::Config }
  end

  describe ".configure" do
    specify { expect { |b| MOL.configure(&b) }.to yield_control }

    let(:code) { "123" }
    let(:secret) { "secret" }
    let(:app_name) { "APP" }
    let(:currency) { "PHP" }

    before do
      MOL.configure do |config|
        config.code = code
        config.secret = secret
        config.currency = currency
        config.app_name = app_name
        config.sandbox_mode = true
      end
    end

    subject { MOL.config }

    specify { expect(subject).to be_a MOL::Config }
    specify { expect(subject.code).to eq code }
    specify { expect(subject.secret).to eq secret }
    specify { expect(subject.app_name).to eq app_name }
    specify { expect(subject.currency).to eq currency}
    specify { expect(subject.payout_url).to eql "https://sandbox.api.mol.com/payout" }
  end
end
