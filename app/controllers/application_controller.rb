class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "onlinegradebook"
  end

  get '/' do
    if !logged_in?
      erb :index
    else
      redirect "/courses"
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
    end

    def student_id
      @student_id ||= Role.find_by(name: "Student")
    end
  end
end
