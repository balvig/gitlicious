class ProjectsController < ApplicationController

  before_filter :find_author

  def index
    @projects = current_author ? current_author.projects : Project.all
  end

  def show
    @project = Project.find(params[:id])
    @problems = @project.current_problems.by(current_author).includes(:author).includes(:report => :project)
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    if @project.save
      redirect_to(@project, :notice => 'Project imported.')
    else
      render :action => "new"
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      redirect_to(@project, :notice => 'Changes saved.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to(projects_url)
  end

  private

  def find_author
    @author = Author.find(params[:author_id]) if params[:author_id]
  end
end
