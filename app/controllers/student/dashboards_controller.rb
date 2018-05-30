require 'fill_pdfs'

module Student
  class DashboardsController < StudentController
    def show
      @regional_events = RegionalPitchEvent.available_to(
        current_team.submission
      )

      field_value_pairs = {
        'id' => current_account.id,
        'mobileAppName' => current_team.submission.app_name,
        'fullName' => current_account.name,
        'teamName' => current_team.name,
        'region' => FriendlyCountry.(current_account, prefix: false)
      }

      certificate_type = :completion

      FillPdfs.(field_value_pairs, certificate_type)
    end
  end
end
