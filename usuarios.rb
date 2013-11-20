require 'dm-core'
require 'dm-migrations'
require 'sinatra'
require 'sinatra/flash'
require 'sass'

class User
  include DataMapper::Resource
  property :id, Serial
  property :nombre_usuario, String
  property :contrasenia, String
  property :partidas_jugadas, Integer
  property :partidas_ganadas, Integer
  property :partidas_perdidas, Integer
  property :partidas_empatadas, Integer
end

DataMapper.finalize

get '/users' do
  @users = User.all
  haml :users
end

get '/users/new' do
  haml :new_user
end

get '/users/:id' do |id|
  @user = User.get(id)
  haml :show_user
end

#get '/users/:id/edit' do
#  @user = User.get(params[:id])
#  haml :edit_user
#end

post '/users' do
  if (params[:user][:nombre_usuario].empty?) || (params[:user][:contrasenia].empty?)
    flash[:error] = "Error: El usuario o la contraseña no ha sido especificado"
    redirect to ('/users/new')
  elsif User.first(:nombre_usuario => "#{params[:user][:nombre_usuario]}")
    flash[:error] = "El usuario ha sido creado"
    redirect to ('/users/new')
  else
    params[:user]["partidas_jugadas"] = 0
    params[:user]["partidas_ganadas"] = 0
    params[:user]["partidas_perdidas"] = 0
    params[:user]["partidas_empatadas"] = 0
    user = User.create(params[:user])
    puts params[:user]
    puts "#{user.games}"
    flash[:success] = "Usuario creado satisfactoriamente"
    flash[:login] = "Inicio de sesion satisfactorio"
    session["user"] = "#{params[:user][:nombre_usuario]}"
    redirect to("/users/#{user.id}")
  end
end

put 'users/:id' do
  user = User.get(params[:id])
  user.update(params[:user])
  redirect to("/users/#{user.id}")
end

#delete '/users/:id' do
#   User.get(params[:id]).destroy
#   redirect to('/users')
#end

