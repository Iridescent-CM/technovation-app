module ExternalResourceHelper
  def external_chapter_ambassador_training_checkpoint_link(account)
    base_url = ENV.fetch("CHAPTER_AMBASSADOR_TRAINING_CHECKPOINT_BASE_URL")

    params = {
      uid_value: account.id,
      full_name_value: account.full_name,
      email_value: account.email,
      organization_value: account.chapter_ambassador_profile.chapter&.organization_name,
      city_value: account.city,
      state_province_value: account.state_province,
      country_value: account.country
    }

    "#{base_url}?#{params.to_query}"
  end

  def external_chapter_ambassador_training_module_link(module_number)
    ENV.fetch("CHAPTER_AMBASSADOR_TRAINING_MODULE_#{module_number}_URL", "")
  end
end
