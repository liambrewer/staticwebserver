# frozen_string_literal: true

require 'socket'
require_relative 'request'
require_relative 'response'

PUBLIC_DIR = "././public"
PORT = 3000

server = TCPServer.new PORT

loop do
  client = server.accept

  request = Request.new client.gets
  response = Response.new body: ""

  public_files = Dir.glob("#{PUBLIC_DIR}/**/*").reject { |filename| File.directory? filename }.map do |filename|
    {
      path: filename.sub(PUBLIC_DIR, ""),
      content: File.read(filename)
    }
  end

  resource = public_files.find { |file| file[:path] == request.path }

  if !resource.nil?
    # TODO: THIS IS A TERRIBLE WAY TO USE CLASSES
    response.body = resource[:content]
    response.headers = {
      "Content-Type": "text/html",
      "Content-Length": resource[:content].size
    }

    client.puts response
  else
    message = "<!DOCTYPE html><h1>404</h1><p>The requested content was not found on this server.</p>"

    response.status = 404
    response.headers = {
      "Content-Type": "text/html",
      "Content-Length": message.size
    }
    response.body = message

    client.puts response
  end

  client.close
end