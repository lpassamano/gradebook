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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

    def current_user_student?
      current_user.role == Role.find_by(name: "Student")
    end

    def current_user_instructor?
      current_user.role == Role.find_by(name: "Instructor")
    end
  end
end
