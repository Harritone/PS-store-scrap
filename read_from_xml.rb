require_relative 'lib/psgame.rb'
require 'nokogiri'
require 'httparty'
require 'byebug'
require 'ox'

path = File.dirname(__FILE__) + '/data/test.xml'

total = PsGame.from_xml(path)
total.each {|game| game.show}
p total.count

