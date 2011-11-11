class AuthorsController < ApplicationController

  def index
    @authors = Author.order('name ASC')
  end

  def show
    @author = Author.find(params[:id])
  end

end
