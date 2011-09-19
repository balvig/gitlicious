class ReportsController < ApplicationController

  before_filter :find_project

  def create
    @report = @project.reports.build
    @report.save
    redirect_to(@project, :notice => "Report created for #{@report.created_at}")
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end