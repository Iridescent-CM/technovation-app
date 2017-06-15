require 'data-anonymization'
require "pry"
require "bcrypt"

database 'technovation-app_development' do
  strategy DataAnon::Strategy::Blacklist

  source_db adapter: 'postgresql', database: 'technovation-app_development'

  table 'accounts' do
    primary_key 'id' # composite key is also supported
    anonymize 'date_of_birth',
      'first_name',
      'last_name',
      'latitude',
      'longitude',
      'auth_token',
      'consent_token',
      'profile_image',
      'last_login_ip'
    anonymize('profile_image') { |_| nil }
    anonymize('email') { |f| "user-#{f.ar_record.id}@oracle.com" }
    anonymize('password_digest') { |_| BCrypt::Password.create("secret1234") }
  end

  table 'student_profiles' do
    primary_key 'id' # composite key is also supported
    anonymize 'parent_guardian_name'
    anonymize('parent_guardian_email') { |f| "parent-#{f.ar_record.id}@oracle.com" }
  end

  table 'mentor_profiles' do
    primary_key 'id' # composite key is also supported
    anonymize('bio') { |_| "Sanitized bio" }
  end

  table 'regional_ambassador_profiles' do
    primary_key 'id' # composite key is also supported
    anonymize('bio') { |_| "Sanitized bio" }
  end

  table 'background_checks' do
    primary_key 'id' # composite key is also supported
    anonymize 'candidate_id', 'report_id'
  end

  table 'consent_waivers' do
    primary_key 'id' # composite key is also supported
    anonymize 'electronic_signature'
  end

  table 'parental_consents' do
    primary_key 'id' # composite key is also supported
    anonymize 'electronic_signature'
  end

  table 'honor_code_agreements' do
    primary_key 'id' # composite key is also supported
    anonymize 'electronic_signature'
  end

  table 'team_member_invites' do
    primary_key 'id' # composite key is also supported
    anonymize('invitee_email') { |f| "invitee-#{f.ar_record.id}@oracle.com" }
  end

  table 'signup_attempts' do
    primary_key 'id' # composite key is also supported
    anonymize 'activation_token',
      'signup_token',
      'pending_token',
      'admin_permission_token'
    anonymize('email') { |f| "attempt-#{f.ar_record.id}@oracle.com" }
  end

  table 'teams' do
    primary_key 'id' # composite key is also supported
    anonymize('team_photo') { |_| nil }
    anonymize 'latitude', 'longitude'
  end
end
