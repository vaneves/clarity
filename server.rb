#!/usr/bin/env ruby

require 'socket'
require 'yaml'
require './lib/clarity'
require './lib/application'
require './lib/request'
require './lib/response'

server = Clarity.new
server.run