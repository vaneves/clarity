#!/usr/bin/env ruby

class Response
  attr_reader :client, :headers, :body
  def initialize(client)
    @client = client
    @headers = []
    @body = ""
  end
  def header(line)
    @headers.push line
  end
  def body(content)
    @body = content
  end
  def send
    @headers.each {|line| @client.puts line}
    @client.puts "\r\n"
    @client.puts @body
    @client.close
  end
end