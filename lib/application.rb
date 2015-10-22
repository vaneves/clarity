#!/usr/bin/env ruby

class Application
  attr_reader :client, :request, :response, :root, :index
  def initialize(client, root, index)
    @client = client
    @request = Request.new client
    @response = Response.new client
    @root = root
    @index = index
  end
  def error(code)
    file = @root + "/#{code}.html"
    if File.exist?(file)
      content = File.read(file)
    else
      content = "Page Not Found"
    end

    @response.header "HTTP/1.1 404 Not Found"
    @response.body content
    @response.send
  end
  def run
    file = @request.file
    if file == "/"
      file << @index
    end
    path = @root + file

    puts "[#{Time.now}] request in file #{file}"

    if File.exist?(path)
      content = File.read(path)

      time = Time.now
      time = time.strftime "%a, %d %b %Y %H:%M:%S %Z"

      @response.header "HTTP/1.1 200 OK"
      @response.header "Date: " + time
      @response.header "Server: Clarity/0.1"
      @response.header "Cache-Control: no-cache"
      @response.header "Keep-Alive: timeout=3, max=100"
      @response.header "Connection: close"
      @response.body content
      @response.send
    else
      error(404)
    end
  end
end