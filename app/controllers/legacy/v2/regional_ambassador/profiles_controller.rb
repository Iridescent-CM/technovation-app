module Legacy
  module V2
    require "will_paginate/array"

    module RegionalAmbassador
      class ProfilesController < RegionalAmbassadorController
        include Concerns::ProfileController

        def index
          params[:season] ||= Season.current.year
          params[:type] ||= "All"
          params[:per_page] = 25 if params[:per_page].blank?
          params[:page] = 1 if params[:page].blank?

          params[:team_status] = "All" if params[:team_status].blank?
          params[:parental_consent_status] = "All" if params[:parental_consent_status].blank?
          params[:cleared_status] = "All" if params[:cleared_status].blank?

          @accounts = RegionalAccount.(current_ambassador, params).distinct

          params[:sort] = "accounts.created_at desc" if params[:sort].blank?

          case params[:sort]
          when "type asc"
            @accounts = @accounts.sort { |a, b| a.type_name <=> b.type_name }
          when "type desc"
            @accounts = @accounts.sort { |a, b| b.type_name <=> a.type_name }
          when "division asc"
            @accounts = @accounts.sort { |a, b| a.division <=> b.division }
          when "division desc"
            @accounts = @accounts.sort { |a, b| b.division <=> a.division }
          when "school asc"
            @accounts = @accounts.sort { |a, b|
              a.get_school_company_name <=> b.get_school_company_name
            }
          when "school desc"
            @accounts = @accounts.sort { |a, b|
              b.get_school_company_name <=> a.get_school_company_name
            }
          else
            @accounts = @accounts.order(params[:sort])
          end

          @accounts = @accounts.paginate(per_page: params[:per_page], page: params[:page])

          if @accounts.empty?
            @accounts = @accounts.paginate(per_page: params[:per_page], page: 1)
          end
        end

        def profile_params
          [
            :organization_company_name,
            :job_title,
            :ambassador_since_year,
            :bio,
          ]
        end

        private
        def account
          current_ambassador
        end

        def edit_profile_path
          edit_regional_ambassador_profile_path
        end

        def account_param_root
          :regional_ambassador_profile
        end
      end
    end
  end
end
