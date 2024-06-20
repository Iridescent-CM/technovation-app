module ExternalResourceHelper
  def external_chapter_ambassador_training_checkpoint_link(account)
    base_url = ENV.fetch("CHAPTER_AMBASSADOR_TRAINING_CHECKPOINT_BASE_URL")

    params = {
      uid_value: account.id,
      name_value: "#{account.first_name} #{account.last_name}",
      email_value: account.email
    }

    "#{base_url}?#{params.to_query}"
  end

  def external_chapter_ambassador_training_module_link(module_number)
    ENV.fetch("CHAPTER_AMBASSADOR_TRAINING_SLIDES_MODULE_#{module_number}_URL", "")
  end
end
