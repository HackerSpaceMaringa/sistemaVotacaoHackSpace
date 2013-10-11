
require './gui/urna.rb'
require './gui/autenticar.rb'

class Votacao < Qt::Widget
   slots 'fechar()'

   def initialize parent
      super parent

      @opcoes = Qt::TabWidget.new self

      init_ui

      @opcoes.addTab @urna, "Urna Liberada"
      @opcoes.addTab @autent, "Autenticar"

      connect @urna, SIGNAL('accepted()'), self, SLOT('fechar()')
      connect @autent, SIGNAL('accepted()'), self, SLOT('fechar()')
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
      if @autent == nil
         @autent = Autenticar.new
      end
      if @urna == nil
         @urna = Urna.new
      elsif not @urna.isVisible
         @urna.show
      end
   end

   def fechar
      hide
   end
end



