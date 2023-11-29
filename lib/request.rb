class Request
  attr_accessor :method, :path, :http_protocol

  # @param [TCPSocket] socket
  def initialize(socket)
    @method, @path, @http_protocol = socket.gets.split " ", 3
  end
end