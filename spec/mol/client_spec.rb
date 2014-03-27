require 'spec_helper'
require 'mol/client'
require 'addressable/uri'

describe MOL::Client do
  let(:code) { "123" }
  let(:secret) { "secret" }
  let(:app_name) { "APP" }
  let(:currency) { "PHP" }


  describe "#initialize" do
    context "when a configuration is initialized" do
      before do
        MOL.configure do |config|
          config.code = code
          config.secret = secret
          config.currency = currency
          config.app_name = app_name
          config.sandbox_mode = true
        end
      end

      subject { MOL::Client.new }
      specify { expect(subject.application_code).to eq code }
      specify { expect(subject.application_secret).to eq secret }
      specify { expect(subject.application_name).to eq app_name }
      specify { expect(subject.currency).to eq currency }
    end

    context "when options are being passed on initialization" do
      let(:newcode) { "newcode" }
      let(:newsecret) { "newsecret" }
      let(:newapp_name) { "NEWAPP" }
      let(:newcurrency) { "USD" }
      let(:sandbox_mode) { "true" }

      subject { MOL::Client.new(
        application_code: newcode, 
        application_secret: newsecret,
        application_name: newapp_name,
        currency: newcurrency
      )}

      specify { expect(subject.application_code).to eq newcode }
      specify { expect(subject.application_secret).to eq newsecret }
      specify { expect(subject.application_name).to eq newapp_name }
      specify { expect(subject.currency).to eq newcurrency }
    end
  end

  describe "#invoke_payment_request" do
    before(:each) do
      MOL.configure do |config|
        config.code = "2AlVzxuFI17wywBcPah3eqhmEOanKtFK"
        config.secret = "zSIsecRXfy7bdbT1mAH3BNHJWlAKhQXh"
        config.currency = currency
        config.app_name = app_name
        config.sandbox_mode = true
      end
    end

    context "when parameters are valid and complete" do
      let(:options) do
        {
          reference_id: "asdf123",
          version: "v1",
          channel_id: 1,
          amount: 1000,
          return_url: "https://merchant.com/pay",
          description: "This is a product",
          customer_id: 1
        }
      end

      let(:mock_signature) { "valid123" }
      let(:mock_payment_id) { "MPO106166" }
      let(:mock_payment_url) { "http://molv4.molsolutions.com/PaymentchannelSandbox/PayoutAPICall.aspx?token=123valid"}

      let(:mock_payload) do
        %Q{
          referenceId=#{options[:reference_id]}&
          version=#{options[:version]}&
          channelId=#{options[:channel_id]}&
          amount=#{options[:amount]}&
          returnUrl=#{CGI.escape(options[:return_url])}&
          description=#{URI.escape(options[:description])}&
          customerId=#{options[:customer_id]}&
          applicationCode=#{MOL.config.code}&
          currencyCode=#{MOL.config.currency}&
          signature=#{mock_signature}
        }.split.join
      end

      let(:mock_response) do
        {
          "applicationCode" => MOL.config.code,
          "referenceId" => options[:reference_id],
          "version" =>  options[:version],
          "amount" => options[:amount],
          "currencyCode" => options[:currency_code],
          "paymentId" => mock_payment_id,
          "paymentUrl" => mock_payment_url,
          "signature" => mock_signature
        }.to_json
      end

      let(:mock_headers) do
        {
          "cache-control" => ["no-cache"], 
          "pragma" => ["no-cache"],
          "content-length" => ["520"], 
          "content-type" => ["application/json; charset=utf-8"],
          "expires" => ["-1"], 
          "x-aspnet-version" => ["4.0.30319"], 
          "x-powered-by" => ["ASP.NET"], 
          "date" => ["Thu, 27 Mar 2014 08:58:33 GMT"], 
          "connection"=>["close"] 
        }
      end

      let(:client) { MOL::Client.new }
      let(:json) { JSON.parse response.body }

      before do
        expect_any_instance_of(Signature).to receive(:digest).and_return(mock_signature)
        stub_request(:post, "#{MOL.config.payout_url}/payments").
          with(body: mock_payload).
          to_return(status: 200, body: mock_response, headers: mock_headers)
      end

      subject(:response) { client.invoke_payment_request options }
      
      it "should return a HTTParty::Response object" do
        #expect(response).to be_a HTTParty::Response
        response.class.should eq HTTParty::Response
      end

      specify { expect(response.code).to eq 200 }

      specify do
        %w{applicationCode referenceId version amount currencyCode paymentId paymentUrl signature}.each do |key|
          expect(json.include?(key)).to be true
        end
      end
    end
  end
end
