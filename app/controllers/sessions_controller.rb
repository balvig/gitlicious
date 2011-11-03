class SessionsController < ApplicationController
  def create
    session[:author_id] = params[:author_id]
    redirect_to projects_url, :notice => 'Signed in!'
  end

  def destroy
    session[:author_id] = nil
    redirect_to :back
  end
end
