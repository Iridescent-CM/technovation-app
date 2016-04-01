module Teams
  module DefaultParams

    def self.params(team_params)
      default_values = { confirm_region: false, confirm_acceptance_of_rules: false }
      return default_values.merge(team_params) if Setting.get_boolean('manual_region_selection')
      team_params
    end
  end
end
