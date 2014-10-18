require "sinatra"
require "json"
require "koala"
require "pry"
require "firebase"
require "./classforms.rb"

enable :sessions

# sets user id in session hask
def set_userid (user_id)
  session[:user_id] = user_id
end


get '/class' do
  # all classes
#  classes = get_posts(user_id)
  erb :"classes.html.erb"
end

get '/class/add/:id' do
  
  erb :"add_classes.html.erb"
end

post '/class/add/:id' do
  user = session[:user_id]
  teacher = params[:teacher_handle]
  classhashtag = params[:class_hashtag]
  add_class user, teacher, classhashtag
  redirect :to "/class"
end


post '/class/delete/:id' do
  user = session[:user_id]
  teacher = params[:teacher_handle]
  classhashtag = params[:class_hashtag]
  
  remove_user user, teacher, classhashtag
  redirect :to "/class"
end


get '/login' do
  
end

post '/login' do
    
    username = params['username']
    password = params['password']

    base_uri = 'https://dazzling-fire2679.firebaseio.com/users'
    firebase = Firebase::Client.new(base_uri)
    
   # checkuser = firebase.get(username {'username' => username})
#    checkuser = firebase.get(password {'password' => password})
    # does user exist?
    database_password = firebase.get(base_uri + "/" + username + "/password").body
 
    if database_password == password
        # success
        session[:user] = username
        redirect to "/profile"
    else
        # unsuccessful login
        redirect to "/login"
        puts "invalid Username, Password or Account does not exist"
    end
    
    # yes? -> check password
    
    # checking password -> password matches?
    
end
