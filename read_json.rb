require 'json'
require_relative 'lib/psgame'

path = File.dirname(__FILE__) + '/data/test.json'

total = PsGame.read_from_json(path)
total.each {|game| game.show}

