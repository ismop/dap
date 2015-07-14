module Api
  module V1
    class ContextsController < Api::ApiController
      load_and_authorize_resource :context
      respond_to :json

      def index
        respond_with @contexts.order(:id)
      end

      def show
        respond_with @context
      end

    end
  end
end