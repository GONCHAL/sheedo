require "rubygems"
require "sinatra"
require "pony"
require "rack-flash"
require "rack/contrib"
require "i18n"
require "i18n/backend/fallbacks"
require "./env" if File.exists?("env.rb")

configure do
  I18n::Backend::Simple.send(:include,I18n::Backend::Fallbacks)
  I18n.load_path=Dir[File.join(settings.root,"locales","*.yml")]
  I18n.backend.load_translations
  I18n.enforce_available_locales = false
end

enable :sessions
use Rack::Flash
use Rack::Locale

before do
  locale = env["rack.locale"].scan(/^[a-z]{2}/).first
  I18n.locale = (locale == "en") ? "en" : "es"
end

get "/" do
  erb :index
end

get "/historia" do
  erb :historia
end

get "/index" do
  erb :index
end

get "/catalogo" do
  erb :catalogo
end

get "/contacto" do
  erb :contacto
end

post"/send" do
  send_mail
  flash[:notice] = "Thank you. The Mailman is on His Way :)"
  redirect("/contacto")
end

def send_mail
  Pony.mail(to:      ENV["email"],
            from:    params[:email],
            subject: params[:subject],
            via:     :smtp,
            body:    mail_body,
            via_options: {
              address:              "smtp.gmail.com",
              port:                 587,
              enable_starttls_auto: true,
              user_name:            ENV["EMAIL"],
              password:             ENV["PASSWORD"],
              authentication:       "login"
            })
end

def mail_body
  %(Email:   #{params[:email]}
    Nombre:  #{params[:name]}
    Mensaje: #{params[:message]})
end
