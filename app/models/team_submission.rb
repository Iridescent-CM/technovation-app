class TeamSubmission < ActiveRecord::Base
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
  mount_uploader :pitch_presentation, FileProcessor

  scope :current, -> {
    joins(season_registrations: :season).where("seasons.year = ?", Season.current.year)
  }

  belongs_to :team
  has_many :screenshots, -> { order(:sort_position) }
  has_one :business_plan

  has_one :technical_checklist
  accepts_nested_attributes_for :technical_checklist

  has_many :season_registrations, dependent: :destroy, as: :registerable
  has_many :seasons, through: :season_registrations

  validate -> {
    unless integrity_affirmed?
      errors.add(:integrity_affirmed, :accepted)
    end
  }

  def development_platform_text
    if development_platform == "Other"
      ["Other", "-", development_platform_other].join(' ')
    else
      development_platform
    end
  end

  def embed_code(method)
    if send(method) and send(method).match(/youtu/)
      id = send(method)[/v=(.+)$/, 1]

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
    end
  end
end
