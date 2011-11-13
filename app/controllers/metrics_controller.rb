class MetricsController < ApplicationController

  def index
    @metrics = Metric.all
  end

  def edit
    @metric = Metric.find(params[:id])
  end

  def update
    @metric = Metric.find(params[:id])

    if @metric.update_attributes(params[:metric])
      redirect_to(metrics_url, :notice => 'Metric was successfully updated.')
    else
      render :action => "edit"
    end
  end

end
