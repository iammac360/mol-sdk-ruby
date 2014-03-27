require 'digest/md5'

module MOL
  class Signature
    attr_accessor :sorted_hash

    def initialize(params)
      @sorted_hash = Hash[params.sort]
    end

    def digest
      Digest::MD5.hexdigest(@sorted_hash.values.join + MOL.config.secret)
    end
  end
end
