require './sistemaVotacao.rb'
require './autenticacao.rb'
require 'fileutils'

def init
   @stl = SomebodyToLove.new
end

def set_inputPassword(title,label)
   dlg = Qt::InputDialog.new self
   dlg.setWindowTitle title
   dlg.setLabelText label
   dlg.setTextEchoMode Qt::LineEdit::Password
   return dlg
end

def menuVotar stl
   senha = nil
   while senha == nil or senha.strip.empty?
      dialog = set_inputPassword("Autenticando...", "Digite a senha:")
      dialog.exec
      if dialog.result == Qt::Dialog::Accepted
         senha = dialog.textValue
      elsif dialog.result == Qt::Dialog::Rejected
         return "fail"
      end
   end
   senha = senha.strip
   #  Qt::MessageBox.information self, "Senha", "senha: #{senha}\n==? #{stl.senha?(senha)}\nstl-senha: #{stl.senha}"
   if(!stl.senha?(senha))
      Qt::MessageBox.critical self, "Erro!", "Senha incorreta!"
      return "fail"
   end
   return senha
end

def menuIniciarVotacao
   init

   FileUtils.mkdir_p("backup")
   begin
      FileUtils.cp(".votos","backup/votos#{Time.now}")
      FileUtils.cp(".listaRAs","backup/listaRAs#{Time.now}")
   rescue Exception => e
   end

   system ("clear")

   senha = 100000 + Random.rand(1000000)

   if File.exists?(".listaRAs")

      linha = File.readlines(".votos").first
      while true
         begin
            #puts "Digite a senha da votacao anterior: "
            senhaAntiga = nil
            while senhaAntiga == nil or senhaAntiga.strip.empty?
               dialog = set_inputPassword("Reinicializando...", "Digite a senha da votacao anterior:")
               dialog.exec
               if dialog.result == Qt::Dialog::Accepted
                  senhaAntiga = dialog.textValue
               elsif dialog.result == Qt::Dialog::Rejected
                  Qt::MessageBox.warning self, "Saindo...", "Saindo da Aplicacao"
                  abort
               end
               #              senhaAntiga = Qt::InputDialog.getText self, "Reinicializando", "Digite a senha da votacao anterior:", Qt::LineEdit::Password
            end
            senhaAntiga = senhaAntiga.strip
            if("ok" == @stl.descriptografar(linha,senhaAntiga))
               if !@stl.trocarSenha(senhaAntiga,senha)
                  Qt::MessageBox.critical self, "Erro!", "Falha ao recuperar votacao!"
                  abort
               end
               Qt::MessageBox.information self, "Sucesso!", "Votacao reinicializada.\nATENCAO! Anote a NOVA senha: #{senha}"
               @stl.senha = senha
               return @stl
            end
         rescue StandardError => e
            Qt::MessageBox.critical self, "Erro!", "Some blackMAGIC happened. Its fucked!!"
            abort
         end
      end
   else
      @stl.iniciarVotacao("#{senha}")
      Qt::MessageBox.information self, "Sucesso!", "Votacao inicializada.\nATENCAO! Anote a senha: #{senha}"
      return @stl
   end
end


def menuMostrarResultado stl
   senha = nil
   while senha == nil or senha.strip.empty?
      dlg = set_inputPassword("Autenticando...", "Digite a senha:")
      dlg.exec
      if dlg.result == Qt::Dialog::Accepted
         senha = dlg.textValue
      elsif dlg.result == Qt::Dialog::Rejected
         return "fail"
      end
   end
   if (!stl.senha? senha)
      Qt::MessageBox.critical self, "Erro!", "Senha incorreta!"
      return "fail"
   end
   return senha
end


#menuIniciarVotacao
#menuInicial
