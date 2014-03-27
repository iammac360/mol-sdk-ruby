require 'addressable/uri'
require 'httparty'
require 'active_support/core_ext'

module MOL
  class Client
    attr_accessor :application_code, :application_secret, :application_name, :currency, :sandbox_mode

    def initialize(options = {})
      @application_code = options[:application_code] || ::MOL.config.code
      @application_secret = options[:application_secret] || ::MOL.config.secret
      @application_name = options[:application_name] || ::MOL.config.app_name
      @currency = options[:currency] || ::MOL.config.currency
      @sandbox_mode = options[:sandbox_mode] || ::MOL.config.sandbox_mode
    end

    def invoke_payment_request(options)
      options[:application_code] ||= @application_code
      options[:currency_code] ||= @currency
      options[:signature] = Signature.new(options).digest
      params =  {}
      options.each { |k,v| params[k.to_s.camelize(:lower)] = v }
      HTTParty.post("#{::MOL.config.payout_url}/payments", body: params)
    end
  end
end
