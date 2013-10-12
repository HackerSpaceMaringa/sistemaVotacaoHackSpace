
class KeyButton < Qt::PushButton
   def initialize(name,parent)
      super name, parent

      setFont Qt::Font.new "Courier New", 30
      setFixedSize 125, 60
   end
end
