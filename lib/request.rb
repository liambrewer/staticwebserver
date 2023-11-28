class Request
  attr_accessor :method, :path, :http_protocol

  # @param [String] request
  def initialize(request)
    @method, @path, @http_protocol = request.split
  end
end