class TeamSubmission < ActiveRecord::Base
  extend FriendlyId
  friendly_id :team_name_and_app_name, use: :slugged

  enum stated_goal: %w{
    Poverty
    Environment
    Peace
    Equality
    Education
    Health
  }

  enum development_platform: %w{
    App\ Inventor\ 2
    Swift\ or\ XCode
    Java
    C++
    PhoneGap/Apache\ Cordova
    Other
  }

  attr_accessor :step

  after_commit -> { SeasonRegistration.register(self) }, on: :create

  mount_uploader :source_code, FileProcessor

  scope :current, -> {
    joins(season_registrations: :season).where("seasons.year = ?", Season.current.year)
  }

  belongs_to :team, touch: true
  has_many :screenshots, -> { order(:sort_position) }, dependent: :destroy

  has_one :business_plan, dependent: :destroy
  accepts_nested_attributes_for :business_plan

  has_one :pitch_presentation, dependent: :destroy
  accepts_nested_attributes_for :pitch_presentation

  has_one :technical_checklist, dependent: :destroy
  accepts_nested_attributes_for :technical_checklist

  has_many :season_registrations, dependent: :destroy, as: :registerable
  has_many :seasons, through: :season_registrations

  has_many :submission_scores, dependent: :destroy

  validate -> {
    unless integrity_affirmed?
      errors.add(:integrity_affirmed, :accepted)
    end
  }

  delegate :name,
           :division_name,
           :photo,
    to: :team,
    prefix: true

  def source_code_external_url=(url)
    sanitized_url = if url.match(%r{\Ahttps?://})
            url
          elsif not url.blank?
            url.sub(%r{\A(?:\w+://)?}, "http://")
          end

    super(sanitized_url)
  end

  def pitch_presentation_complete?
    pitch_presentation.present? and pitch_presentation.persisted?
  end

  def complete?
    team.team_photo.present? and

      not app_name.blank? and

      not app_description.blank? and

      not stated_goal.blank? and

      not stated_goal_explanation.blank? and

      not pitch_video_link.blank? and

      not demo_video_link.blank? and

      screenshots.many? and

      technical_checklist_completed? and

      not detect_source_code_url.blank? and

      not development_platform_text.blank? and

      business_plan_complete_or_not_required?  and

      pitch_presentation_complete_or_not_required?
  end

  def country
    team.creator.country
  end

  def state_province
    team.state_province
  end

  def division_id
    team.division_id
  end

  def junior_division?
    team_division_name == "junior"
  end

  def senior_division?
    team_division_name == "senior"
  end

  def development_platform_text
    if development_platform == "Other"
      ["Other", "-", development_platform_other].join(' ')
    else
      development_platform
    end
  end

  def business_plan_url
    if business_plan.file_uploaded?
      business_plan.file_url
    else
      business_plan.remote_file_url
    end
  end

  def pitch_presentation_url
    if pitch_presentation.file_uploaded?
      pitch_presentation.file_url
    else
      pitch_presentation.remote_file_url
    end
  end

  def detect_source_code_url
    if source_code_file_uploaded?
      source_code_url
    else
      source_code_external_url
    end
  end

  def source_code_url_text
    if source_code_file_uploaded?
      source_code_url.match(/\/([\s\w\-\.%\(\)\]\[]+)$/)[1]
    else
      source_code_external_url
    end
  end

  def business_plan_url_text
    if business_plan and business_plan.file_uploaded?
      business_plan.file_url.match(/\/([\s\w\-\.%\(\)\]\[]+)$/)[1]
    elsif business_plan
      business_plan.remote_file_url
    end
  end

  def pitch_presentation_url_text
    if pitch_presentation and pitch_presentation.file_uploaded?
      pitch_presentation.file_url.match(/\/([\s\w\-\.%\(\)\]\[]+)$/)[1]
    elsif pitch_presentation
      pitch_presentation.remote_file_url
    end
  end

  def technical_checklist_started?
    !!technical_checklist and technical_checklist.attributes.values.any? { |v| not v.blank? }
  end

  def technical_checklist_completed?
    !!technical_checklist and technical_checklist.completed?
  end

  def embed_code(method)
    if send(method) and send(method).match(/youtu/)
      id = send(method)[/v=([\w\-]+[^&])&?.*$/, 1]

      %{<iframe
          width="100%"
          height="315"
          src="https://www.youtube.com/embed/#{id}"
          frameborder="0"
          allowfullscreen>
        </iframe>}.strip_heredoc
    elsif send(method) and send(method).match(/vimeo/)
      id = send(method)[/\/(\d+)$/, 1]

      %{<iframe
          src="https://player.vimeo.com/video/#{id}"
          width="100%"
          height="360"
          frameborder="0"
          webkitallowfullscreen
          mozallowfullscreen
          allowfullscreen>
        </iframe>}.strip_heredoc
    else
      ""
    end
  end

  private
  def business_plan_complete_or_not_required?
    junior_division? or

    (senior_division? and not business_plan_url_text.blank?)
  end

  def pitch_presentation_complete_or_not_required?
    not team.selected_regional_pitch_event.live? or

    (team.selected_regional_pitch_event.live? and pitch_presentation_complete?)
  end

  def team_name_and_app_name
    "#{app_name} by #{team_name}"
  end

  def should_generate_new_friendly_id?
    super || team_name_and_app_name.parameterize != slug
  end
end
