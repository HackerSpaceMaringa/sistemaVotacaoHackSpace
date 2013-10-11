
require './gui/urna.rb'
require './gui/autenticar.rb'

class Votacao < Qt::Widget
   slots 'fechar()'

   def initialize parent
      super parent

      @opcoes = Qt::TabWidget.new self
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
      @autent = Autenticar.new
      @urna = Urna.new

      @opcoes.addTab @urna, "Urna Liberada"
      @opcoes.addTab @autent, "Autenticar"

      connect @urna, SIGNAL('accepted()'), self, SLOT('fechar()')
      connect @autent, SIGNAL('accepted()'), self, SLOT('fechar()')
   end

   def fechar
      hide
   end
end



