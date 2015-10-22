#!/usr/bin/env ruby

require 'socket'
require './lib/application'
require './lib/request'
require './lib/response'

class Clarity
  attr_accessor :ip, :port, :root, :index
  def initialize
    @ip = "localhost"
    @port = 2000
    @root = "./www"
    @index = "index.html"
  end
  def run
    server = TCPServer.new @ip, @port
    puts "Running server http://#{ip}:#{port} in #{root}"
    loop do
      Thread.start(server.accept) do |client|
        app = Application.new client, @root, @index
        app.run
      end
    end
  end
end

server = Clarity.new
server.run