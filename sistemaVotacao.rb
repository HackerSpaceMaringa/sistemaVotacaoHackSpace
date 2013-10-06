require 'encryptor'
require 'base64'
require 'digest/md5'
require 'sysinfo'

begin
    require 'io/console'
rescue LoadError
end

@senha = ""
@sysinfo = SysInfo.new

def adicionarFimRandomico(string)
    return "#{string}#{100+Random.rand(99)}"
end

def removerFimRandomico(string)
    return string[0..-4]
end

def replace(filepath, regexp, *args, &block)
    content = File.read(filepath).gsub(regexp, *args, &block)
    File.open(filepath, 'wb') { |file| file.write(content) } 
end

def criptografar(txt,senha)
    return Base64.encode64(
        Encryptor.encrypt(:value => adicionarFimRandomico(txt), :key => "#{@senha}#{@sysinfo.hostname}"))
end

def descriptografar(txt,senha)
    return removerFimRandomico(
        Encryptor.decrypt(:value => Base64.decode64(txt), :key => "#{@senha}#{@sysinfo.hostname}"))
end

def iniciarVotacao(senha)
    @senha = senha
    log = File.new("logs", "w+")
    listaRAs = File.new("listaRAs","w+")
    votos = File.new("votos","w+")

    log.puts(criptografar("ok",senha))
    listaRAs.puts(criptografar("ok",senha))
    votos.puts(criptografar("ok",senha))

    votos.close
    log.puts(generateHash)
    log.close
    listaRAs.close
    puts "Hash: #{generateHash}"
end

def generateHash
    return "#{Digest::MD5.hexdigest(File.read("votos"))}"
end

def checarHash(senha)
    file = File.open("logs","r+")
    file.gets
    oldHash = (file.gets).gsub("\n",'')
    newHash = generateHash
    file.close
    return oldHash == newHash
end

def trocarHash(hash,senha)
    file = File.open("logs","r+")
    firstLine = file.gets
    if(checarSenha(firstLine,senha))
        novoHash = generateHash
        replace("logs",/^#{hash}/mi) do |match|
            novoHash
        end
    else
        return false
    end
    file.close
end

def checarSenha(line,senha)
    begin
        return ("ok" == descriptografar(line,senha)) && (senha == @senha)
    rescue Exception => e
        return false;
    end
end

def senha?(senha)
    log = File.open("logs")
    return checarSenha(log.gets,senha)
end

def votar(value,ra,senha)
    begin
        logs = File.open "logs"
        logs.gets
        hashAntigo = logs.gets
        logs.close

        if(checarHash senha)
            if(not possuiRA?(ra,senha))
                file = File.open("votos","r+")
                firstLine = file.gets
                aleatorio = Random.rand 10000

                if(checarSenha(firstLine,senha))
                    file.seek(1, IO::SEEK_END)
                    file.puts(criptografar("#{value}#{aleatorio}",senha))
                    file.close
                    adicionarVotante(ra,senha)
                    trocarHash(hashAntigo,senha)
                    return true
                else
                    file.close
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    rescue Exception => e
        puts e
    end
    return false
end

def adicionarVotante(ra,senha)
    i = 0
    linha = ""
    if(not possuiRA?(ra,senha))
        File.readlines("listaRAs").each do |line|
            linha = line
            if(i==0)
                if(checarSenha(line,senha))
                    i=1
                else
                    return false
                end
            else
                if(Random.rand(1000) < 250)
                    break
                end
            end
        end
        linha = linha.gsub("+","\\\\+")
        replace("listaRAs",/^#{linha}/mi) do |match|
            "#{match}#{criptografar("#{ra}",senha)}"
        end
    else
        return false
    end
end

def possuiRA?(ra,senha)
    i = 0
    File.readlines("listaRAs").each do |line|
        if(i==0)
            if(checarSenha(line,senha))
                i=1
            else
                return false
            end
        else
            value = descriptografar(line,senha)
            if(value == ra)
                return true
            end
        end
    end
    return false
end

def listaDeVotantes(senha)
    i = 0
    File.readlines("listaRAs").each do |line|
        if(i==0)
            if(checarSenha(line,senha))
                i=1
            else
                return false
            end
        else
            value = descriptografar(line,senha)
            puts value
        end
    end

end

def resultadoVotos(senha)
    votos = {}
    i = 0
    File.readlines("votos").each do |line|
        if(i==0)
            if(checarSenha(line,senha))
                i=1
            else
                return false
            end
        else
            value = descriptografar(line,senha)[0]
            if(votos.include? value)
                votos[value] = votos[value] + 1
            else
                votos[value] = 1
            end
        end
    end
    print votos
    puts
end

if STDIN.respond_to?(:noecho)
    def get_password(prompt="Password: ")
        print prompt
        STDIN.noecho(&:gets).chomp
    end
else
    def get_password(prompt="Password: ")
        `read -s -p "#{prompt}" password; echo $password`.chomp
    end
end

#begin

#senha = ""
#senha = get_password("Senha: ")
#puts
#puts possuiRA?("67620",senha)
#puts adicionarVotante("67620",senha)
#adicionarVotante("#{Random.rand(100)}",senha)
#resultadoVotos(senha)
#listaDeVotantes(senha)
#rescue Exception => e
#   puts e
#end
#puts votar(1,"67620",senha)
#senha = 100000 + Random.rand(1000000)
#puts senha
#iniciarVotacao("#{senha}")
