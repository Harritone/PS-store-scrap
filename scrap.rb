require_relative 'lib/psgame.rb'
require 'nokogiri'
require 'httparty'
require 'byebug'
require 'ox'
require 'json'
require 'yaml'

xml_path = File.dirname(__FILE__) + '/data/test.xml'
json_path = File.dirname(__FILE__) + '/data/test.json'
yaml_path = File.dirname(__FILE__) + '/data/test.yaml'

games_1500 = PsGame.from_url('https://store.playstation.com/ru-ru/grid/STORE-MSF75508-GAMESUNDER202018/')
games_720 = PsGame.from_url('https://store.playstation.com/ru-ru/grid/STORE-MSF75508-GAMESUNDER2102/')

result = games_1500.merge games_720

PsGame.save_to_yaml(yaml_path, result)

