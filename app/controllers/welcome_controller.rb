class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:print_payload]
  # GET /welcome
  def index
    render plain: "Welcome to the app, Sud :)"
  end

  def print_payload
    payload = request.raw_post
    Rails.logger.info "Received payload: #{payload}"
    render json: { received: payload }, status: :ok
  end

end
