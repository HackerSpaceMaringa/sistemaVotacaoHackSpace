
require 'Qt'
require './mainWindow.rb'

App = Qt::Application.new ARGV
Main.new
App.exec
