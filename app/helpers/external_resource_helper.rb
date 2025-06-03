module ExternalResourceHelper
  def external_ambassador_training_checkpoint_link(account)
    base_url = ENV.fetch("#{current_scope.upcase}_TRAINING_CHECKPOINT_BASE_URL")

    organization_value = account.chapter_ambassador? ?
      account.chapter_ambassador_profile.chapter&.organization_name : account.club_ambassador_profile.club&.name

    params = {
      uid_value: account.id,
      full_name_value: account.full_name,
      email_value: account.email,
      organization_value: organization_value,
      city_value: account.city,
      state_province_value: account.state_province,
      country_value: account.country
    }

    "#{base_url}?#{params.to_query}"
  end
end
