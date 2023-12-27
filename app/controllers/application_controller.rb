class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  BadRequest = Class.new(StandardError)

  rescue_from BadRequest, with: :bad_request_response

  private

  def bad_request_response(exception)
    render plain: exception.message, status: :bad_request
  end
end
