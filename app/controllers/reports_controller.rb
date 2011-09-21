class ReportsController < ApplicationController

  before_filter :find_project

  def create
    @report = @project.reports.build
    if @report.save!
      redirect_to(:back, :notice => "Report created for #{@report.created_at}")
    else
      redirect_to(:back, :alert => "Could not create report")
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end