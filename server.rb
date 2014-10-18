require "sinatra"
require "json"
require "koala"
require "pry"
require "firebase"

enable sessions:

post '/login' do
    
    username = params['username']
    password = params['password']

    base_uri = 'https://mypavement.firebaseio.com/users'
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
    
