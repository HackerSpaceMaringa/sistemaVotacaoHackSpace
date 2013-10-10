
require './gui/urna.rb'
require './gui/autenticar.rb'

class Votacao < Qt::Widget

   def initialize parent
      super parent

      init_ui
   end

   def setPassword senha
      @autent.setPassword senha
      @urna.setPassword senha
   end

   def setStl stl
      @autent.somebodyToLove = stl
      @urna.somebodyToLove = stl
   end

   def init_ui
      opcoes = Qt::TabWidget.new self

      @autent = Autenticar.new
      @urna = Urna.new

      opcoes.addTab @urna, "Urna Liberada"
      opcoes.addTab @autent, "Autenticar"
   end
end



