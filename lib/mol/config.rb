module MOL
  class Config

    attr_accessor :code, :secret, :app_name, :currency, :sandbox_mode

    def initialize
      @code = ''
      @secret = ''
      @app_name = ''
      @currency = 'MYR'
      @sandbox_mode = false
    end

    def payout_url
      sandbox_mode ? "https://sandbox.api.mol.com/payout/" : "https://api.mol.com/payout/"
    end
  end
end
