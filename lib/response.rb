class Response
  attr_accessor :status, :headers, :body

  # @param [Integer] status
  # @param [Array] headers
  # @param [String] body
  def initialize(status: 200, headers: [], body:)
    @status = status
    @headers = headers
    @body =  body
  end

  def to_s
    str = "HTTP/1.1 #{status}"
    unless @headers.empty?
      str += "\r\n#{@headers.map { |key, value| " #{key}: #{value}" }.join("\r\n")}"
    end
    str + "\r\n\r\n#{body}"
  end
end