#!/usr/bin/env ruby

class Request
  attr_reader :client
  def initialize(client)
    @client = client
  end
  def file
    first_line = client.gets
    parts = first_line.split(" ")
    return parts[1]
  end
end