#!/usr/bin/env ruby

require 'socket'

class Clarity
  attr_reader :response, :file, :path
  attr_accessor :ip, :port, :root, :index

  def initialize
    @ip = "localhost"
    @port = 2000
    @root = "./www"
    @index = "index.html"
  end
  def receive(client)
    inputHeader = []
    first = client.gets
    line = client.gets
    while line != "\r\n"
      inputHeader.push(line)
      line = client.gets
    end
    @file = file first
    @path = @root + @file
    puts "[#{Time.now}] request in file " + @file + "\n"
  end
  def file(line)
    parts = line.split(" ")
    method = parts[0]
    file = parts[1]
    version = parts[2]

    if file == "/"
      file << @index
    end
    return file
  end
  def header(client)
    time = Time.now
    time = time.strftime "%a, %d %b %Y %H:%M:%S %Z"

    client.puts "Date: " + time
    client.puts "Server: Clarity/0.1"
    client.puts "Cache-Control: no-cache"
    client.puts "Keep-Alive: timeout=3, max=100"
    client.puts "Connection: Keep-Alive"
    client.puts "\r\n"
  end
  def response(client)
    if File.exist?(@path)
      body = File.read(@path)

      client.puts "HTTP/1.1 200 OK"
      header client
      client.puts body
      client.close
    else
      error(client, 404)
    end
  end
  def error(client, code)
    file = @root + "/#{code}.html"
    if File.exist?(file)
      body = File.read(file)
    else
      body = "Page Not Found"
    end

    client.puts "HTTP/1.1 404 Not Found"
    header client
    client.puts body
    client.close
  end
  def run
    server = TCPServer.new @ip, @port
    puts "Running server http://#{ip}:#{port} in #{root}\n"
    loop do
      client = server.accept
      receive client
      response client
    end
  end
end

server = Clarity.new
server.run