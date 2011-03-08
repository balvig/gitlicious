class TagsController < ApplicationController
  
  before_filter :find_project


  def show
    @tag = @project.tags.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  def edit
    @tag = @project.tags.find(params[:id])
  end

  def update
    @tag =  @project.tags.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to(@project, :notice => 'Tag was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end
