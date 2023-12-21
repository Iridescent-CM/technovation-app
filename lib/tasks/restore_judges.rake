# May 11, 2018 backup:
#
# email: "aouahab@jobrouter.fr",
# account_id: 60919
# judge_profile_id: 5593
#
# email: "eljazouliyassine@gmail.com"
# account 2 id: 60908
# judge profile id 5579
#
desc "Restore judge data from lib/restore_accounts.json"
task restore_judges: :environment do
  ActiveRecord::Base.transaction do
    accounts = JSON.parse(File.read("./lib/restore_accounts.json"))

    accounts.each do |json|
      pwd_digest = json.delete("password_digest")
      judge_profile_json = json.delete("judge_profile")
      original_profile_id = judge_profile_json.delete("original_id")

      account = AccountFromJudgeRestoreJson.call(json)
      profile = JudgeProfileFromRestoreJson.call(account, judge_profile_json)

      account.skip_existing_password = true
      account.password = "somethingwaltminusbear"
      account.save!
      account.update_column(:password_digest, pwd_digest)

      # SubmissionScore.with_deleted.where(judge_profile_id: original_profile_id).each do |score|
      #   score.judge_profile = account.judge_profile
      #   score.deleted_at = nil

      #   score.save

      #   unless score.reload.judge_profile_id == account.judge_profile.id
      #     raise "Judge not saved #{json['email']}"
      #   end
      # end

      # current_score_count = account.reload.judge_profile
      #                         .submission_scores.current_round.count

      # original_count_from_backup = judge_profile_json['quarterfinals_scores_count']

      # unless current_score_count >= original_count_from_backup
      #   raise "Scores not restored? #{json['email']}"
      # end
    end
  end
end

module AccountFromJudgeRestoreJson
  def self.call(json)
    account = Account.new

    json.keys.each do |key|
      account.public_send("#{key}=", json[key])
    end

    account
  end
end

module JudgeProfileFromRestoreJson
  def self.call(account, json)
    profile = account.build_judge_profile
    event_id = json.delete("event_id")

    json.keys.each do |key|
      profile.public_send("#{key}=", json[key])
    end

    if event = RegionalPitchEvent.find_by(id: event_id)
      profile.events << event
    end

    profile
  end
end
