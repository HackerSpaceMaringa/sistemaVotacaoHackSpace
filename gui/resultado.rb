
class Resultado < Qt::Widget
   attr_accessor :somebodyToLove, :password

   def initialize
      super

      setWindowTitle "Resultado dos Votos"
   end

   def setStl stl
      @somebodyToLove = stl
   end

   def setPassword pwd
      @password = pwd
   end

   def init_ui
      vbox = Qt::VBoxLayout.new self
      hbox = Qt::HBoxLayout.new

      lbRes = Qt::Label.new "Resultado:", self
      votos = @somebodyToLove.resultadoVotos @password
      lbRa = Qt::Label.new "Alunos votantes:", self
      alunos = @somebodyToLove.listaDeVotantes @password
      btEnd = Qt::PushButton.new "Encerrar", self

      if (votos == false) or (alunos == false)
         Qt::MessageBox.critical self, "Erro Grave!", "ATENCAO! ELEICAO CORROMPIDA!"
         abort
      end

      hbox.addWidget btEnd, 1, Qt::AlignCenter

      vbox.addWidget lbRes
      votos.each do |key, voto|
         vbox.addWidget Qt::Label.new "Candidato #{key} -> #{voto}", self
      end
      vbox.addWidget Qt::Label.new "", self
      vbox.addWidget lbRa
      alunos.each do |aluno|
         vbox.addWidget Qt::Label.new "Aluno RA#{aluno}", self
      end
      vbox.addWidget Qt::Label.new "", self
      vbox.addLayout hbox

      connect btEnd, SIGNAL('clicked()'), Qt::Application.instance, SLOT('quit()')
   end
end

