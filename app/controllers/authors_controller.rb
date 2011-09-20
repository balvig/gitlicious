class AuthorsController < ApplicationController

  def index
    @authors = Author.all
    redirect_to new_project_url unless @authors.size > 0
  end


  def show
    @author = Author.find(params[:id])
  end

end
