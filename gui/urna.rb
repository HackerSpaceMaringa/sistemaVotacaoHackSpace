
require './gui/teclado.rb'
require './gui/confDialog.rb'

class Urna < Qt::Widget
	slots 'votar_gui()', 'limpar_gui()', 'cancelar_gui()', 'realizar_voto()', 'voto_rejeitado()'

	def initialize
		super

		init_ui
	end

	def init_ui
		vbox = Qt::VBoxLayout.new self
		hbox = Qt::HBoxLayout.new
		hbox1 = Qt::HBoxLayout.new
		hbox2 = Qt::HBoxLayout.new
		hbox3 = Qt::HBoxLayout.new
		hbox4 = Qt::HBoxLayout.new

		raLabel = Qt::Label.new "RA:", self
		@raEdit = Qt::LineEdit.new self
		@numbers = Teclado.new self
		btVote = Qt::PushButton.new "VOTAR", self
		btLimpar = Qt::PushButton.new "LIMPAR", self
		btCancelar = Qt::PushButton.new "CANCELAR", self
		
		hbox.addWidget btVote
		hbox.addWidget btLimpar
		hbox.addWidget btCancelar

		vbox.addLayout hbox1
		vbox.addWidget raLabel
		vbox.addWidget @raEdit
		vbox.addLayout hbox2
		vbox.addLayout hbox3
		vbox.addWidget @numbers
		vbox.addLayout hbox4
		vbox.addLayout hbox

		connect btVote, SIGNAL('clicked()'), self, SLOT('votar_gui()')
		connect btLimpar, SIGNAL('clicked()'), self, SLOT('limpar_gui()')
		connect btCancelar, SIGNAL('clicked()'), self, SLOT('cancelar_gui()')
	end

	def setPassword senha
		@password = senha
	end

	def resetar
		limpar_gui
		limpar_info
	end

	def cancelar_gui
		hide
	end

	def limpar_gui
		@numbers.setResult ""
	end

	def votar_gui
		confirm = Confirmation.new "Votar?", "Confirma o voto?", self

		connect confirm, SIGNAL('accepted()'), self, SLOT('realizar_voto()')
		connect confirm, SIGNAL('rejected()'), self, SLOT('voto_rejeitado()')

		confirm.show
	end

	def realizar_voto
		if votar(@numbers.getResult.to_i, @raEdit.text, @password)
			Qt::MessageBox.information self, "Sucesso!", "Votacao completada com sucesso!"
			resetar
			hide
		else
			Qt::MessageBox.critical self, "Falha!", "ATENCAO! Seu voto nao pode ser computado!"
		end
	end

	def voto_rejeitado
		limpar_gui
	end

	def limpar_info
		@raEdit.setText ""
	end
end
