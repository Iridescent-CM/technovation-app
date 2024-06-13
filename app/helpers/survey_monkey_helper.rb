module SurveyMonkeyHelper
  def chapter_ambassador_training_checkpoint_link(account)
    base_url = "https://www.surveymonkey.com/r/DCM3VZX"

    params = {
      uid_value: account.id,
      name_value: "#{account.first_name}#{account.last_name}",
      email_value: account.email
    }

    "#{base_url}?#{params.to_query}"
  end
end
