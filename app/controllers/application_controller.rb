class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "onlinegradebook"
  end

  get '/' do
    erb :index
  end

  get '/logout' do
    session.clear if logged_in?
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      Student.find_by(id: session[:user_id]) || Instructor.find_by(id: session[:user_id])
    end
  end
end
