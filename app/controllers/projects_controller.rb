class ProjectsController < ApplicationController

  before_filter :find_author

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @reports = @project.reports.limit(100)
    @results = @author.current_problems_in(@project).group_by(&:result) if @author
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
      redirect_to([@project, :metrics], :notice => '<strong>Project imported.</strong> Now configure the metrics for your project!'.html_safe)
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

  private

  def find_author
    @author = Author.find(params[:author_id]) if params[:author_id]
  end
end
