require 'mol/version'

module MOL
  autoload :Config, 'mol/config'

  class << self
    attr_accessor :config

    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end
  end
end
