require 'encryptor'
require 'base64'
require 'digest/md5'
require 'sysinfo'
require 'highline/import'

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

def criptografar(txt,senha=@senha)
   return Base64.encode64(
      Encryptor.encrypt(:value => adicionarFimRandomico(txt), :key => "#{senha}#{@sysinfo.hostname}"))
end

def descriptografar(txt,senha=@senha)
   return removerFimRandomico(
      Encryptor.decrypt(:value => Base64.decode64(txt), :key => "#{senha}#{@sysinfo.hostname}"))
end

def trocarSenha(senhaAntiga,senha)
   if checarHash senhaAntiga
      if File.exists?(".votos") && File.exists?(".listaRAs")
         linha = File.readlines(".votos").first
         if "ok" == descriptografar(linha, senhaAntiga)

            logN = File.new(".logsN", "w+")
            votosN = File.new(".votosN","w+")
            listaRAsN = File.new(".listaRAsN","w+")

            File.readlines(".votos").each do |line|
               votosN.puts(criptografar(descriptografar(line,senhaAntiga),senha))
            end

            File.readlines(".listaRAs").each do |line|
               listaRAsN.puts(criptografar(descriptografar(line,senhaAntiga),senha))
            end

            votosN.close
            listaRAsN.close

            begin
               FileUtils.mv(".votosN",".votos")
               FileUtils.mv(".listaRAsN",".listaRAs")
            rescue Exception => e
               puts e
               return false
            end

            logN.puts(criptografar("ok",senha))
            logN.puts(generateHash)
            logN.close

            begin
               FileUtils.mv(".logsN",".logs")
            rescue Exception => e
               puts e
               return false
            end

            @senha = senha
            puts "Hash: #{generateHash}"
            return true
         end
      end
   end
   return false
end

def iniciarVotacao(senha)
      @senha = senha
      log = File.new(".logs", "w+")
      listaRAs = File.new(".listaRAs","w+")
      votos = File.new(".votos","w+")

      log.puts(criptografar("ok",senha))
      listaRAs.puts(criptografar("ok",senha))
      votos.puts(criptografar("ok",senha))

      votos.close
      listaRAs.close
      log.puts(generateHash)
      log.close
      puts "Hash: #{generateHash}"
end

def generateHash
   return "#{Digest::MD5.hexdigest(File.read(".votos")+File.read(".listaRAs"))}"
end

def checarHash(senha)
   file = File.open(".logs","r+")
   file.gets
   oldHash = (file.gets).gsub("\n",'')
   newHash = generateHash
   file.close
   return oldHash == newHash
end

def trocarHash(hash,senha)
   file = File.open(".logs","r+")
   firstLine = file.gets
   if(checarSenha(firstLine,senha))
      novoHash = generateHash
      replace(".logs",/^#{hash}/mi) do |match|
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
   log = File.open(".logs")
   return checarSenha(log.gets,senha)
end

def votar(value,ra,senha)
   begin
      logs = File.open ".logs"
      logs.gets
      hashAntigo = logs.gets
      logs.close

      if(checarHash senha)
         if(not possuiRA?(ra,senha))
            file = File.open(".votos","r+")
            firstLine = file.gets

            if(checarSenha(firstLine,senha))
               file.seek(1, IO::SEEK_END)
               file.puts(criptografar("#{value}",senha))
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
      File.readlines(".listaRAs").each do |line|
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
      replace(".listaRAs",/^#{linha}/mi) do |match|
         "#{match}#{criptografar("#{ra}",senha)}"
      end
   else
      return false
   end
end

def possuiRA?(ra,senha)
   i = 0
   File.readlines(".listaRAs").each do |line|
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
   if(checarHash senha)
      i = 0
      File.readlines(".listaRAs").each do |line|
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
      return true
   else
      return false
   end
end

def resultadoVotos(senha)
   if(checarHash senha)

      votos = {}
      i = 0
      File.readlines(".votos").each do |line|
         if(i==0)
            if(checarSenha(line,senha))
               i=1
            else
               return false
            end
         else
            value = descriptografar(line,senha)
            if(votos.include? value)
               votos[value] = votos[value] + 1
            else
               votos[value] = 1
            end
         end
      end
      print votos
      puts
      return true
   else
      return false
   end
end

def get_password(prompt="Password: ")
   ask("#{prompt}: ") { |q| q.echo = "*" }
end

