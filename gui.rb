require './sistemaVotacao.rb'
require './autenticacao.rb'
require 'fileutils'

def pedirSenha
   system("clear")
   puts "Digite a senha para liberacao: "
   senha = ""
   senha = get_password("Senha: ")
   system("clear")
   return senha
end

def tentarAutenticar
   system("clear")
   puts "RA: "
   ra = gets.chomp
   senha = get_password("Senha: ")
   return autenticar(ra,senha),ra
end

def votacao(ra,senha)
   while(true)
      system("clear")
      puts "DIGITE O NUMERO DE QUEM VOCE DESEJA VOTAR:"
      voto = gets.chomp
      puts "Comfimar (1) ou Cancelar (2)?"
      op = gets.chomp
      if op == "1"
         if(votar(voto.to_i,ra,senha))
            system("clear")
            puts "Votacao completada com sucesso!"
         else
            puts "ATENCAO! Seu voto nao pode ser computado!"
         end
         gets.chomp
         break
      end
   end
end

def menuVotar
   senha = nil
   while senha == nil or senha.strip.empty?
   	  senha = Qt::InputDialog.getText self, "Votando...", "Digite a senha:", Qt::LineEdit::Password
   end
   senha = senha.strip
   if(!senha?(senha))
      Qt::MessageBox.critical self, "Erro!", "Senha incorreta!"
      return "fail"
   end
   return senha
end

def urnaLivre
    puts "RA do votante: "
    ra = gets.chomp
	votacao(ra,senha)
end

def menuIniciarVotacao

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
            if("ok" == descriptografar(linha,senhaAntiga))
               if !trocarSenha(senhaAntiga,senha)
				  Qt::MessageBox.critical self, "Erro!", "Falha ao recuperar votacao!"
                  abort
               end
			   Qt::MessageBox.information self, "Sucesso!", "Votacao reinicializada.\nATENCAO! Anote a NOVA senha: #{senha}"
               return
            end
         rescue StandardError => e
         end
         Qt::MessageBox.critical self, "Erro!", "Senha incorreta!"
      end
   else
      iniciarVotacao("#{senha}")
      Qt::MessageBox.information self, "Sucesso!", "Votacao inicializada.\nATENCAO! Anote a senha: #{senha}"
      return
   end
end

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

def menuInicial
   while true
      begin
         system ("clear")
         puts "Menu: "
         puts "1) Novo voto"
         puts "2) Mostrar resultado"

         puts "Digite o codigo da acao: "
         value = gets.chomp

         if value == "1"
            menuVotar
         elsif value == "2"
            menuMostrarResultado
         end
      rescue StandardError => e
         puts e
         gets.chomp
      end
   end
end

#menuIniciarVotacao
#menuInicial
