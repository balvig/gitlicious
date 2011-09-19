class ProjectsController < ApplicationController

  before_filter :find_author

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @commits = @project.commits.order('commited_at DESC').limit(400)
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
      redirect_to([@project, :metrics], :notice => '<strong>Project imported.</strong> Now configure the metrics for your project.'.html_safe)
    else
      render :action => "new"
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Changes saved.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  def import_commits
    @project = Project.find(params[:id])
    if @project.import_commits!
      redirect_to @project, :notice => 'New commits imported'
    else
      redirect_to @project, :alert => 'Error importing new commits'
    end
  end
  
  private
  
  def find_author
    @author = Author.find(params[:author_id]) if params[:author_id]
  end
end
