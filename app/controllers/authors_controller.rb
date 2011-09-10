class AuthorsController < ApplicationController
  
  before_filter :find_project

  def index
    @authors = Author.all
  end


  def show
    @author = @project.authors.find(params[:id])
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end

end
