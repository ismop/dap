module Api
  module V1
    class ThreatAssessmentRunsController < Api::ApiController
      #skip_authorization_check
      load_and_authorize_resource :threat_assessment_run
      respond_to :json

      def create
        threat_assessment_run = ThreatAssessmentRun.create(threat_assessment_run_params)
        threat_assessment_run.save!
        render json: threat_assessment_run, serializer: ThreatAssessmentRunSerializer, status: :created
      end

      def index
        tas = @threat_assessment_runs.where(filter)
        if params.keys.include? 'sort_by'
          case params['sort_by']
          when 'start_date'
            if params.keys.include? 'sort_order'
              case params['sort_order']
              when 'asc'
                tas = tas.order('start_date ASC')
              when 'desc'
                tas = tas.order('start_date DESC')
              else
                # ASC by default
                tas = tas.order('start_date ASC')
              end
            else
              # ASC by default
              tas = tas.order('start_date ASC')
            end

          when 'end_date'
            if params.keys.include? 'sort_order'
              case params['sort_order']
                when 'asc'
                  tas = tas.order('end_date ASC')
                when 'desc'
                  tas = tas.order('end_date DESC')
                else
                  # ASC by default
                  tas = tas.order('end_date ASC')
              end
            else
              # ASC by default
              tas = tas.order('end_date ASC')
            end

          else
            if params.keys.include? 'sort_order'
              case params['sort_order']
                when 'asc'
                  tas = tas.order('id ASC')
                when 'desc'
                  tas = tas.order('id DESC')
                else
                  # ASC by default
                  tas = tas.order('id ASC')
              end
            else
              # ASC by default
              tas = tas.order('id ASC')
            end
          end
        end

        if params.keys.include? 'limit'
          unless params['limit'].to_i.blank? or params['limit'].to_i == 0
            tas = tas.take(params['limit'].to_i)
          end
        end

        respond_with tas

      end

      def show
        respond_with @threat_assessment_run
      end

      def update
        @threat_assessment_run.update_attributes!(threat_assessment_run_params)
        render json: @threat_assessment_run, serializer: ThreatAssessmentRunSerializer
      end

      private

      def threat_assessment_run_params
        params.require(:threat_assessment_run).permit(:name, :status, :start_date, :end_date, :experiment_id, :sort_by, :sort_order, :limit)
      end
    end
  end
end