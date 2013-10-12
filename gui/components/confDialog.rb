
class Confirmation < Qt::Dialog
	def initialize(title, msg, parent)
		super parent
		
		setWindowTitle title
		setModal true

		vbox = Qt::VBoxLayout.new self
		hbox = Qt::HBoxLayout.new

		message = Qt::Label.new msg, self
		btSim = Qt::PushButton.new "SIM", self
		btNao = Qt::PushButton.new "NAO", self

		hbox.addWidget btSim
		hbox.addWidget btNao

		vbox.addWidget message
		vbox.addLayout hbox

		connect btSim, SIGNAL('clicked()'), self, SLOT('accept()')
		connect btNao, SIGNAL('clicked()'), self, SLOT('reject()')
	end
end
