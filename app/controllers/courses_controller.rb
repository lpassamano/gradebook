class CoursesController < ApplicationController

  get '/courses' do
    @user = current_user
    erb :"courses/index"
  end

  get '/courses/new' do
    erb :"courses/new"
  end
end
