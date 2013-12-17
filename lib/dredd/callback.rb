class Dredd::Callback
  attr_reader :url, :secret

  def initialize(url, secret)
    @url = url
    @secret = secret
  end
end
