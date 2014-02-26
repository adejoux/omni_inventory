class EsSession
  def initialize
    Elasticsearch::Client.new
  end
end