require 'oauth'
require 'twitter'
require 'pry'
require 'sinatra'

set :server, 'thin'

consumer_key = 'ZFN35beMHxovlqKB2KRIGoH4X'
consumer_secret = 'jm64owKNK6IYU6ojhWSePvSPRYqSWQV6ntPAp0Z8g817tG3SNT'

get '/auth/twitter' do
    @callback_url = "http://stationapp-c9-stationapp.c9.io/auth/twitter/callback"
    @consumer = OAuth::Consumer.new("ZFN35beMHxovlqKB2KRIGoH4X","jm64owKNK6IYU6ojhWSePvSPRYqSWQV6ntPAp0Z8g817tG3SNT", :site => "https://api.twitter.com", :authorize_path => '/oauth/authorize')
    
    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    session[:request_token] = @request_token
    redirect to @request_token.authorize_url(:oauth_callback => @callback_url)
end

get '/auth/twitter/callback' do
    access_token = session[:request_token].get_access_token(:oauth_verifier => params["oauth_verifier"])
  oauth_token = access_token.params[:oauth_token]
  oauth_token_secret = access_token.params[:oauth_token_secret]
  user_id = access_token.params[:user_id]
  
    base_uri = 'https://dazzling-fire-2679.firebaseio.com/users' + session[:user]
    firebase = Firebase::Client.new(base_uri)
   
    addtwitter = firebase.set("twitter", {oauth_token: oauth_token, oauth_token_secret: oauth_token_secret, user_id: user_id})
"Account Created. Go to http://stationapp-c9-stationapp.c9.io/twitterinfo"

end
