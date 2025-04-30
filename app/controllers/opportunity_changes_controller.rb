class OpportunityChangesController < ActionController::Base
    skip_before_action :verify_authenticity_token, only: :update
    FILE_PATH = Rails.root.join('tmp', 'latest_opportunity_change.json')
  
    def update
      File.write(FILE_PATH, request.body.read)
      head :ok
    end
  
    def show
      if File.exist?(FILE_PATH)
        @payload = File.read(FILE_PATH)
      else
        @payload = 'No Opportunity change event received yet.'
      end
      respond_to do |format|
        format.html
        format.json { render json: { payload: @payload } }
      end
    end
  end