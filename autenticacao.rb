require 'net/http'

def autenticar(usuario,senha)
   uri = URI('http://www.npd.uem.br/menuAluno/ValidaMenuAluno')
   res = Net::HTTP.post_form(uri, 'usuario' => usuario, 'se_usuario' => senha)
   return !(/alert\("Usu/ =~ res.body)
end

