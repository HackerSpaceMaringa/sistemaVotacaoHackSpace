
require './gui/components/keyButtons.rb'

class Teclado < Qt::GroupBox
	slots 'click_0()', 'click_1()', 'click_2()', 'click_3()', 'click_4()', 'click_5()', 'click_6()', 'click_7()', 'click_8()', 'click_9()'
	def initialize wid
		super "Teclado", wid

		create_keyboard
	end

	def create_keyboard
		vbox = Qt::VBoxLayout.new self
		hbox = Qt::HBoxLayout.new
		hbox1 = Qt::HBoxLayout.new
		hbox2 = Qt::HBoxLayout.new
		hbox3 = Qt::HBoxLayout.new
		hbox4 = Qt::HBoxLayout.new
		@result = Qt::Label.new "", self
		@result.setAlignment Qt::AlignHCenter
		b0 = KeyButton.new "0", self
		b1 = KeyButton.new "1", self
		b2 = KeyButton.new "2", self
		b3 = KeyButton.new "3", self
		b4 = KeyButton.new "4", self
		b5 = KeyButton.new "5", self
		b6 = KeyButton.new "6", self
		b7 = KeyButton.new "7", self
		b8 = KeyButton.new "8", self
		b9 = KeyButton.new "9", self

		connect b0, SIGNAL('clicked()'), self, SLOT('click_0()')
		connect b1, SIGNAL('clicked()'), self, SLOT('click_1()')
		connect b2, SIGNAL('clicked()'), self, SLOT('click_2()')
		connect b3, SIGNAL('clicked()'), self, SLOT('click_3()')
		connect b4, SIGNAL('clicked()'), self, SLOT('click_4()')
		connect b5, SIGNAL('clicked()'), self, SLOT('click_5()')
		connect b6, SIGNAL('clicked()'), self, SLOT('click_6()')
		connect b7, SIGNAL('clicked()'), self, SLOT('click_7()')
		connect b8, SIGNAL('clicked()'), self, SLOT('click_8()')
		connect b9, SIGNAL('clicked()'), self, SLOT('click_9()')

		hbox.addWidget @result

		hbox1.addWidget b1
		hbox1.addWidget b2
		hbox1.addWidget b3

		hbox2.addWidget b4
		hbox2.addWidget b5
		hbox2.addWidget b6

		hbox3.addWidget b7
		hbox3.addWidget b8
		hbox3.addWidget b9

		hbox4.addWidget b0, 0, Qt::AlignCenter

		vbox.addLayout hbox
		vbox.addLayout hbox1
		vbox.addLayout hbox2
		vbox.addLayout hbox3
		vbox.addLayout hbox4

		setLayout vbox
	end

	def getResult
		return @result.text
	end

	def setResult txt
		@result.setText txt
	end

	def click_0
		puts "ativou"
		@result.setText "#{@result.text}#{0}"
	end

	def click_1
		@result.setText "#{@result.text}#{1}"
	end

	def click_2
		@result.setText "#{@result.text}#{2}"
	end

	def click_3
		@result.setText "#{@result.text}#{3}"
	end

	def click_4
		@result.setText "#{@result.text}#{4}"
	end

	def click_5
		@result.setText "#{@result.text}#{5}"
	end

	def click_6
		@result.setText "#{@result.text}#{6}"
	end

	def click_7
		@result.setText "#{@result.text}#{7}"
	end

	def click_8
		@result.setText "#{@result.text}#{8}"
	end

	def click_9
		@result.setText "#{@result.text}#{9}"
	end

end
