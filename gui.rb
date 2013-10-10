require './sistemaVotacao.rb'
require './autenticacao.rb'
require 'fileutils'

def init
   @stl = SomebodyToLove.new
end

def menuVotar stl
   senha = nil
   while senha == nil or senha.strip.empty?
      senha = Qt::InputDialog.getText self, "Votando...", "Digite a senha:", Qt::LineEdit::Password
   end
   senha = senha.strip
   Qt::MessageBox.information self, "Senha", "senha: #{senha}\n==? #{stl.senha?(senha)}\nstl-senha: #{stl.senha}"
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
               senhaAntiga = Qt::InputDialog.getText self, "Reinicializando", "Digite a senha da votacao anterior:", Qt::LineEdit::Password
            end
            senhaAntiga = senhaAntiga.strip
            if("ok" == @stl.descriptografar(linha,senhaAntiga))
               if !@stl.trocarSenha(senhaAntiga,senha)
                  Qt::MessageBox.critical self, "Erro!", "Falha ao recuperar votacao!"
                  abort
               end
               Qt::MessageBox.information self, "Sucesso!", "Votacao reinicializada.\nATENCAO! Anote a NOVA senha: #{senha}"
               return @stl
            end
         rescue StandardError => e
         end
         Qt::MessageBox.critical self, "Erro!", "Senha incorreta!"
      end
   else
      @stl.iniciarVotacao("#{senha}")
      Qt::MessageBox.information self, "Sucesso!", "Votacao inicializada.\nATENCAO! Anote a senha: #{senha}"
      return @stl
   end
end

=begin
def menuMostrarResultado
   system("clear")
   puts "Votacao sera terminada. Comfirma? (s/n)"
   value = gets.chomp
   if value == "s"
      senha = pedirSenha
      if(senha? senha)
         system("clear")
         puts "Resultado: "
         res = resultadoVotos senha
         puts "Alunos votantes: "
         res2 = listaDeVotantes senha
         if !res || !res2
            abort("ATENCAO! ELEICAO CORROMPIDA!")
         end
         abort("Votacao encerrada")
      else
         puts "SENHA INCORRETA!"
         gets.chomp
      end
   elsif value == "n"
      return
   end
end
=end

#menuIniciarVotacao
#menuInicial
