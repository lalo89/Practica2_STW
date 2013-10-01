require 'rack'
require 'twitter'
require './configure'

class Twitt

  def call env
    req = Rack::Request.new(env)
    res = Rack::Response.new 
    res['Content-Type'] = 'text/html'
    username = (req["user"] && req["user"] != '') ? req["user"] : ''
    user_tweets = (!username.empty?) ? usuario_registrado?(username) : "No se ha introducido ningún usuario"

    res.write <<-"EOS"
      <!DOCTYPE HTML>
      <html>
        <head>
          <meta charset="UTF-8">
          <title>Practica2_STW</title>
        </head>
        <body>
          <section>
            <h2>Practica2_STW</h2>
            <form action="/" method="post">
              Introduzca un usuario de Twitter para ver su ultimo twitt <input type="text" name="user" autofocus><br>
              <input type="submit" value="Confirmar">
            </form>
          </section>
          
          <section>
            <p> ------------------------------------------------------------------------------------------------------ </p>
            #{username}<br><br>#{user_tweets}
          </section>
        </body>
      </html>
    EOS
    res.finish
  end

  def usuario_registrado?(user)
    begin
      Twitter.user_timeline(user).first.text
    rescue
      "El usuario introducido no es correcto"
    end
  end
end

servidor = ARGV.shift || 'thin'
puerto = ARGV.shift || '9292'

Rack::Server.start(
  :app => Twitt.new,
  :Port => puerto,
  :server => servidor
)