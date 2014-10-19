require "sinatra"
require "json"
require "koala"
require "pry"
require "firebase"
require "./classforms.rb"
require 'omniauth'
require 'omniauth-twitter'

configure do
  enable :sessions
  use OmniAuth::Builder do
    provider :twitter, 'BSuhlPmwPyPpQXVx486tWWnfn', 'fMdOju0tjM9lvovnUidJqwdNxM06QDmW9UCB4VWhHnlRXORZjm'
  end

end


helpers do
  # define a current_user method, so we can be sure if an user is
  # authenticated
  def current_user
    !session[:user_id].nil?
  end
end

before do
  # we do not want to redirect to twitter when the path info starts
  # with /auth/
  pass if request.path_info =~ /^\/auth\//
  pass if request.path_info == "/"
  # /auth/twitter is captured by omniauth:
    # when the path info matches /auth/twitter, omniauth will redirect
  # to twitter
  redirect to('/auth/twitter') unless current_user
end



get '/' do
  erb :"login.html"
end


get '/class' do
  # get list of classes
#  classes = get_posts(user_id)
  erb :"classes.html.erb"
end

get '/posts' do
  # displays a list of all posts for all classes
  posts = get_posts(session[:user_id])
  "stub"
end

get '/class/add/:id' do
  
  erb :"add_classes.html.erb"
end

get '/auth/twitter/callback' do
  # probably you will need to create a user in the database too...
  
  session[:user_id] = env['omniauth.auth']['uid']
  # this is the main endpoint to your application
  redirect to('/')
end

get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
  redirect to('/')
end

post '/class/add/:id' do
  user = session[:user_id]
  teacher = params[:teacher_handle]
  classhashtag = params[:class_hashtag]
  add_class user, teacher, classhashtag
  redirect "/class"
end


post '/class/delete/:id' do
  user = session[:user_id]
  teacher = params[:teacher_handle]
  classhashtag = params[:class_hashtag]
  
  remove_user user, teacher, classhashtag
  redirect "/class"
end


get '/login' do
  
end

