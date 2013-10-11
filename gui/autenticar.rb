
require './gui/teclado.rb'
require './gui/confDialog.rb'
require './autenticacao.rb'

class Autenticar < Qt::Dialog
   slots 'realizar_voto()', 'voto_rejeitado()', 'autenticar_gui()', 'votar_gui()', 'limpar_gui()'
   attr_accessor :somebodyToLove

   def initialize
      super

      setModal true
      init_ui
   end

   def init_ui
      vbox = Qt::VBoxLayout.new self
      hbox = Qt::HBoxLayout.new

      raLabel = Qt::Label.new "RA:", self
      @raEdit = Qt::LineEdit.new self
      passLabel = Qt::Label.new "Senha:", self
      @passEdit = Qt::LineEdit.new self
      @passEdit.setEchoMode Qt::LineEdit::Password
      @numbers = Teclado.new self
      btAutenticar = Qt::PushButton.new "AUTENTICAR", self
      @btVotar = Qt::PushButton.new "VOTAR", self
      @btLimpar = Qt::PushButton.new "LIMPAR", self
      btCancelar = Qt::PushButton.new "CANCELAR", self

      hbox.addWidget @btVotar
      hbox.addWidget @btLimpar
      hbox.addWidget btCancelar

      vbox.addWidget raLabel
      vbox.addWidget @raEdit
      vbox.addWidget passLabel
      vbox.addWidget @passEdit
      vbox.addWidget btAutenticar
      vbox.addWidget @numbers
      vbox.addLayout hbox

      connect btAutenticar, SIGNAL('clicked()'), self, SLOT('autenticar_gui()')
      connect @btVotar, SIGNAL('clicked()'), self, SLOT('votar_gui()')
      connect @btLimpar, SIGNAL('clicked()'), self, SLOT('limpar_gui()')
      connect btCancelar, SIGNAL('clicked()'), self, SLOT('accept()')

      disable_bt
   end

   def setPassword senha
      @password = senha
   end

   def disable_bt
      @numbers.setEnabled false
      @btVotar.setEnabled false
      @btLimpar.setEnabled false
   end

   def disable_info
      @raEdit.setEnabled false
      @passEdit.setEnabled false
   end

   def enable_bt
      @numbers.setEnabled true
      @btVotar.setEnabled true
      @btLimpar.setEnabled true
   end

   def enable_info
      @raEdit.setEnabled true
      @passEdit.setEnabled true
   end

   def autenticar_gui
      if autenticar(@raEdit.text, @passEdit.text)
         Qt::MessageBox.information self, "Sucesso!", "RA#{@raEdit.text} autenticado!"
         enable_bt
         disable_info
      else
         Qt::MessageBox.critical self, "Erro!", "Erro ao autenticar RA#{@raEdit.text}"
      end
   end

   def resetar
      limpar_gui
      enable_info
      disable_bt
      limpar_info
   end

   def limpar_info
      @raEdit.setText ""
      @passEdit.setText ""
   end

   def limpar_gui
      @numbers.setResult ""
   end

   def votar_gui
      conf = Confirmation.new "Votar?", "Confirma o voto?", self

      connect conf, SIGNAL('accepted()'), self, SLOT('realizar_voto()')
      connect conf, SIGNAL('rejected()'), self, SLOT('voto_rejeitado()')

      conf.show
   end

   def voto_rejeitado
      limpar_gui
   end

   def realizar_voto
      if @somebodyToLove.votar(@numbers.getResult.to_i, @raEdit.text, @password)
         Qt::MessageBox.information self, "Sucesso!", "Votacao completada com sucesso!"
         resetar
         accept
      elsif resultado == "senha"
         Qt::MessageBox.critical self, "Falha!", "ATENCAO! Seu voto nao pode ser computado!\n(blackMAGIC MOTHERFU***... Culpa do programador)\nSenhas nao batem!"
      elsif resultado == "ra"
         Qt::MessageBox.critical self, "Falha!", "ATENCAO! Seu voto nao pode ser computado!\n(RA ja votou?)"
         resetar
      elsif resultado == "hash"
         Qt::MessageBox.critical self, "Falha!", "ATENCAO! Seu voto nao pode ser computado!\n(Alguem modificou o arquivo?)"
         accept
      elsif resultado == "exception"
         Qt::MessageBox.critical self, "Falha!", "ATENCAO! Seu voto nao pode ser computado!\n(blackMAGIC MOTHERFU***)\nTRY AGAIN..."
         limpar_gui
      end
   end
end
