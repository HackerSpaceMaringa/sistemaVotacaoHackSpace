
require 'Qt'
require './gui/components/confDialog.rb'
require './gui/components/teclado.rb'
require './gui/autenticar.rb'
require './gui/mainWindow.rb'
require './gui/resultado.rb'
require './gui/urna.rb'
require './gui/vote.rb'
require './gui/welcome.rb'
require './autenticacao.rb'
require './gui.rb'
require './sistemaVotacao.rb'

App = Qt::Application.new ARGV
main = Main.new
main.iniciar_votacao_gui
App.exec
