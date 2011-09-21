class ReportsController < ApplicationController

  before_filter :find_project

  def create
    @report = @project.reports.build
    @report.save!
    redirect_to(:back, :notice => "Report created for #{@report.created_at}")
    rescue => e
      redirect_to(:back, :alert => e.message)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end