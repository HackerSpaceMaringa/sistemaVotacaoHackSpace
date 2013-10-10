
require './gui/welcome.rb'
require './gui/vote.rb'
require './gui.rb'

class Main < Qt::MainWindow
	slots 'votar()', 'ver_resultados()'

	def initialize
		super

		setWindowTitle "Sistema de Votacao - HackSpace"
		
		@WIDTH = 500
		@HEIGHT = 500

		showFullScreen

		centralize
		init_ui
		resize @WIDTH, @HEIGHT
		
		show
	end

	def centralize
		@desktop = Qt::DesktopWidget.new

		x = (@desktop.width - @WIDTH)/2
		y = (@desktop.height - @HEIGHT)/2
		
		move x, y
	end

	def init_ui
		set_toolbar
		
		@welcome = Welcome.new self
		@menu_votar = Votacao.new self

		configure_w @menu_votar
		configure_w @welcome

		@welcome.init_ui #welcome.width, welcome.height
		@welcome.show
	end

	def configure_w(widget)
		widget.resize (@desktop.width - (@desktop.width/4)), (@desktop.height - (@desktop.height/4))
		widget.move @desktop.width/8, @desktop.height/8
	end

	def set_toolbar
		color = Qt::Color.new 220, 220, 220
		toolbar = addToolBar "toolbar"
		toolbar.setStyleSheet "QWidget { background-color: %s }" % color.name
		spacer = Qt::Widget.new self

		spacer.setSizePolicy Qt::SizePolicy::Expanding, Qt::SizePolicy::Preferred
		spacer.setVisible true

		quitIcon = Qt::Icon.new "gui/img/sair.png"
		novo_voto = Qt::PushButton.new "Novo Voto", self
		resultados = Qt::PushButton.new "Ver Resultados", self

		toolbar.addWidget novo_voto
		toolbar.addSeparator
		toolbar.addWidget resultados
		toolbar.addWidget spacer
		toolbar.addSeparator
		quit = toolbar.addAction quitIcon, "Sair"
		toolbar.addSeparator

		connect quit, SIGNAL('triggered()'), Qt::Application.instance, SLOT('quit()')
		connect novo_voto, SIGNAL('clicked()'), self, SLOT('votar()')
		connect resultados, SIGNAL('clicked()'), self, SLOT('ver_resultados()')
	end

	def iniciar_votacao_gui
		menuIniciarVotacao
	end

	def votar
		senha = menuVotar
		if senha != "fail"
			@menu_votar.setPassword senha
			@menu_votar.show
		end
	end

	def ver_resultados

	end
end
