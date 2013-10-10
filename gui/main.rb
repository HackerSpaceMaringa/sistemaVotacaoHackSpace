
require 'Qt'
require './gui/mainWindow.rb'

App = Qt::Application.new ARGV
main = Main.new
main.iniciar_votacao_gui
App.exec
