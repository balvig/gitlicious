class CommitsController < ApplicationController
  
  before_filter :find_project

  def show
    @commit = @project.commits.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @commit }
    end
  end

  def edit
    @commit = @project.commits.find(params[:id])
  end

  def update
    @commit =  @project.commits.find(params[:id])

    respond_to do |format|
      if @commit.update_attributes(params[:commit])
        format.html { redirect_to(@project, :notice => 'Commit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @commit.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end
