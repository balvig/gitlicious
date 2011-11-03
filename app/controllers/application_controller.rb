class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_author, :logged_in?

  private

  def current_author
    @current_author ||= Author.find(session[:author_id])
    rescue ActiveRecord::RecordNotFound
      cookies[:author_id] = nil
  end

  def logged_in?
    !!current_author
  end
end
