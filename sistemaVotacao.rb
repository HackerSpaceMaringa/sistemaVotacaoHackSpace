require 'encryptor'
require "base64"
require 'digest/md5'
begin
     require 'io/console'
rescue LoadError
end

@bloqueado = false

def replace(filepath, regexp, *args, &block)
   content = File.read(filepath).gsub(regexp, *args, &block)
   File.open(filepath, 'wb') { |file| file.write(content) }
end

def criptografar(txt,senha)
   return Base64.encode64(Encryptor.encrypt(:value => txt, :key => senha))
end

def descriptografar(txt,senha)
   return Encryptor.decrypt(:value => Base64.decode64(txt), :key => senha)
end

def iniciarVotacao(senha)
   log = File.new("logs", "w+")
   listaRAs = File.new("listaRAs","w+")
   votos = File.new("votos","w+")

   log.puts(criptografar("ok",senha))
   listaRAs.puts(criptografar("ok",senha))
   votos.puts(criptografar("ok",senha))

   votos.close
   puts generateHash
   log.puts(generateHash)
   log.close
   listaRAs.close
   puts "close: " + generateHash
end

def generateHash
   return "#{Digest::MD5.hexdigest(File.read("votos"))}"
end

def checarHash(senha)
   file = File.open("logs","r+")
   file.gets
   oldHash = (file.gets).gsub("\n",'')
   newHash = generateHash
   puts
   puts oldHash + " == " + newHash
   puts
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
   return ("ok" == descriptografar(line,senha)) && (checarHash(senha))
end

def votar(value,senha)
   begin
      logs = File.open("logs")
      logs.gets
      hashAntigo = logs.gets
      logs.close
      file = File.open("votos","r+")
      firstLine = file.gets
      puts firstLine
      aleatorio = Random.rand(10000)
      if(checarSenha(firstLine,senha))
         file.seek(1, IO::SEEK_END)
         file.puts(criptografar("#{value}#{aleatorio}",senha))
         file.close
         trocarHash(hashAntigo,senha)
      else
         file.close
         return false
      end
      return true
   rescue Exception => e
      puts e
   end
   return false
end

def adicionarVotante(ra,senha)
   i = 0
   linha = ""
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
   replace("listaRAs",/^#{linha}/mi) do |match|
      "#{match}#{criptografar("#{ra}",senha)}"
   end
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
         value = descriptografar(line,senha)[0]
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
            votos[value] = 0
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

puts "inicio: " + generateHash
senha = ""
senha = get_password("Senha: ")
puts
adicionarVotante("#{Random.rand(100)}",senha)
#resultadoVotos(senha)
#listaDeVotantes(senha)
#rescue Exception => e
#   puts e
#end
puts votar(1,senha)
#senha = 1000 + Random.rand(10000)
#puts senha
#iniciarVotacao("#{senha}")
