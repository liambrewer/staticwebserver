class Response
  attr_accessor :status, :headers, :body

  # @param [Integer] status
  # @param [Hash] headers
  # @param [String] body
  def initialize(status: 200, headers: {}, body: "")
    @status = status
    @headers = headers
    @body =  body
  end

  def to_s
    str = "HTTP/1.1 #{status}"
    unless @headers.empty?
      str += "\r\n#{@headers.map { |key, value| "#{key}: #{value}" }.join("\r\n")}"
    end
    str += "\r\n\r\n#{body}"
    str
  end

  # @param [String] file_name
  def self.file(file_path)
    content = File.read file_path
    type = mime_type File.extname(file_path)

    self.new status: 200, headers: { "Access-Control-Allow-Origin": "*", "Content-Type": type }, body: content
  end

  # @param [String] content
  def self.html(content)
    self.new status: 200, headers: { "Access-Control-Allow-Origin": "*", "Content-Type": "text/html" }, body: content
  end

  private

  # @param [String] file_ext
  def self.mime_type(file_ext)
    case file_ext
    when ".html", ".htm"
      "text/html"
    when ".js"
      "text/javascript"
    when ".css"
      "text/css"
    else
      "text/plain"
    end
  end
end