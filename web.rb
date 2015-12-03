require "sinatra"
require "pony"
get "/index" do
  erb :index
end
get "/catalogo" do
  erb :catalogo
end
get "/historia" do
  erb :historia
end
get "/contacto" do
  erb :contacto
end
post"/send" do
Pony.mail(to:"infosheedo@gmail.com",
from:params[:email],
body: "#{params[:name]} #{params[:message]}",
subject:"formulario de contcato",
via: :smtp, via_options:{adress:"smtp.gmail",
  port:587,
  enable_starttls_auto:true,
  user_name:"infosheedo@gmail.com",
  password:"",
  authentication:"login"})
  redirect("/contacto")
end
