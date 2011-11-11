class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_author

  private

  def current_author
    @author
  end
end
