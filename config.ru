#!/usr/bin/env ruby

$LOAD_PATH.unshift ::File.expand_path(::File.join(::File.dirname(__FILE__),'lib'))

require 'rubygems'
require 'ronin/ui/web'

Ronin::UI::Web.environment = ENV['ENV'] if ENV.has_key?('ENV')

run Ronin::UI::Web.app
