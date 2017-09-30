class CoursesController < ApplicationController

  get '/courses' do
    @user = current_user
    erb :"courses/index"
  end
end
