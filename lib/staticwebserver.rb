# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'response'

PUBLIC_DIR = "././public"
PORT = 3000

server = TCPServer.new PORT

loop do
  client = server.accept

  request = Request.new client

  public_files = Dir.glob("#{PUBLIC_DIR}/**/*").reject { |f| File.directory? f }.map do |f|
    {
      path: f.sub(PUBLIC_DIR, ""),
      file_path: f
    }
  end

  resource = public_files.find { |file| file[:path] == request.path }

  if !resource.nil?
    client.puts Response.file resource[:file_path]
  else
    response = Response.html "<!DOCTYPE html><h1>404</h1><p>The requested content was not found on this server.</p>"
    response.status = 404

    client.puts response
  end

  client.close
end