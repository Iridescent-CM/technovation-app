class RemoveUnusedIndexes < ActiveRecord::Migration[5.1]
  def change
     remove_index :signup_attempts, :signup_token
     remove_index :signup_attempts, :email
     remove_index :accounts, :referred_by
     remove_index :accounts, :password_reset_token_sent_at
     remove_index :signup_attempts, :account_id
     remove_index :screenshots, :sort_position
     remove_index :mentor_profiles, :virtual
     remove_index :join_requests, :accepted_at
     remove_index :join_requests, :declined_at
     remove_index :exports, :file
     remove_index :team_submissions, :judge_opened_at
     remove_index :background_checks, :candidate_id
     remove_index :background_checks, :report_id
     remove_index :team_submissions, :submission_scores_count
     remove_index :team_submissions, :stated_goal
     remove_index :team_submissions, :semifinals_average_score
     remove_index :team_submissions, :average_unofficial_score
     remove_index :team_submissions, :quarterfinals_average_score
     remove_index :exports, :account_id
     remove_index :regional_ambassador_profiles, :ambassador_since_year
     remove_index :signup_attempts, :activation_token
     remove_index :season_registrations, :status
     remove_index :signup_attempts, :pending_token
     remove_index :mentor_profile_expertises, :expertise_id
     remove_index :parental_consents, :voided_at
     remove_index :accounts, :gender
     remove_index :team_member_invites, :invitee_type
     remove_index :mentor_profiles, :searchable
     remove_index :teams, :division_id
     remove_index :messages, :regarding_type_and_regarding_id
  end
end
