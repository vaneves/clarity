#!/usr/bin/env ruby

require 'socket'
require 'yaml'
require './lib/application'
require './lib/request'
require './lib/response'

class Clarity
  attr_accessor :ip, :port, :root, :index
  def initialize
    config = YAML.load_file('config.yml')
    @ip = config['host']
    @port = config['port']
    @root = config['root']
    @index = config['index']
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