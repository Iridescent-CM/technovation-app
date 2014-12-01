class User < ActiveRecord::Base
  after_create :email_parents_callback

  include FlagShihTzu

  enum role: [:student, :mentor]
  enum referral_category: [
    :friend,
    :colleague,
    :article,
    :internet,
    :social_media,
    :print,
    :web_search,
    :other,
  ]

  validates :first_name, :last_name, presence: true
  validates :home_city, :home_country, presence: true

  has_many :team_requests
  has_many :teams, -> {where 'team_requests.approved = ?', true}, through: :team_requests

  has_flags 1 => :science,
            2 => :engineering,
            3 => :project_management,
            4 => :finance,
            5 => :marketing,
            6 => :design,
            :column => 'expertise'

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.home_city.present? and obj.home_city_changed? }

  def full_address
    [ home_city,
      home_state,
      home_country ].compact.join(', ')
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def current_team
    teams.where(year: Setting.year).first
  end

  def name
    "#{first_name} #{last_name}"
  end

  def division
    now = Setting.cutoff
    dob = birthday
    age_before_cutoff = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    if age_before_cutoff <= 14
      :ms
    else
      :hs
    end
  end

  def email_parents_callback
    if student?
      SignatureMailer.signature_email(current_user).deliver
    end
  end

  protected
  def confirmation_required?
    false
  end
end
