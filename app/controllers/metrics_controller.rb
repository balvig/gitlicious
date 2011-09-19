class MetricsController < ApplicationController

  before_filter :find_project

  def index
    @metrics = @project.metrics
  end

  def show
    @metric = @project.metrics.find(params[:id])
  end

  def new
    @metric = @project.metrics.build
  end

  def edit
    @metric = @project.metrics.find(params[:id])
  end

  def create
    @metric = @project.metrics.build(params[:metric])

    if @metric.save
      redirect_to(@metric, :notice => 'Metric was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @metric = @project.metrics.find(params[:id])

    if @metric.update_attributes(params[:metric])
      redirect_to(@metric, :notice => 'Metric was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @metric = @project.metrics.find(params[:id])
    @metric.destroy

    redirect_to(metrics_url)
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end
