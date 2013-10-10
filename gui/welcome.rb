
class Welcome < Qt::Widget
	def initialize(args)
		super args
	end

	def init_ui
		vbox = Qt::VBoxLayout.new self
		wbox = Qt::HBoxLayout.new
		fbox = Qt::HBoxLayout.new
		hbox = Qt::HBoxLayout.new

		wLabel = Qt::Label.new "Welcome", self
		wLabel.setFont Qt::Font.new "Arial", 70
		fLabel = Qt::Label.new "from", self
		fLabel.setFont Qt::Font.new "Arial", 70
		hLabel = Qt::Label.new "HackerSpace Maringa", self
		hLabel.setFont Qt::Font.new "Arial", 70
#		wLabel.move (width - wLabel.width)/2, (height - wLabel.height)/2

		wbox.addWidget wLabel, 0, Qt::AlignCenter
		fbox.addWidget fLabel, 0, Qt::AlignCenter
		hbox.addWidget hLabel, 0, Qt::AlignCenter

		vbox.addLayout wbox
		vbox.addLayout fbox
		vbox.addLayout hbox
	end
end
