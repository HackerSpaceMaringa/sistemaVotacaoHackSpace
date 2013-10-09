require '../sistemaVotacao.rb'
require '../autenticacao.rb'
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
    senha = pedirSenha
    if(!senha?(senha))
        puts "Senha incorreta!"
        return
    end
    puts "Liberar urna (1) ou logar (2)? (1/2)"
    value = gets.chomp

    if value == "1"
        puts "RA do votante: "
        ra = gets.chomp
        votacao(ra,senha)
    elsif value == "2"
        while true
            res = tentarAutenticar
            if res[0]
                puts "LIBERADO!"
                gets.chomp
                votacao(res[1],senha)
                break
            else
                puts "LOGIN INCORRETO!"
                puts "Tentar novamente? [s/n]"
                value = gets.chomp 
                if value == "n"
                    break
                end
            end
        end
    end
end

def menuIniciarVotacao
    FileUtils.mkdir_p("backup")
    begin
        FileUtils.mv("votos","backup/votos#{Time.now}")
        FileUtils.mv("listaRAs","backup/listaRAs#{Time.now}")
    rescue Exception => e
    end

    system ("clear")
    senha = 100000 + Random.rand(1000000)
    iniciarVotacao("#{senha}")
    puts "Votacao inicializada. ATENCAO! Anote a senha: #{senha}"
    gets.chomp
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
            resultadoVotos senha
            puts "Alunos votantes: "
            listaDeVotantes senha
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