class RegionalAmbassadorProfile < ActiveRecord::Base
  store_accessor :links

  scope :onboarded, -> {
    approved.joins(:account)
      .where("accounts.location_confirmed = ?", true)
      .where("accounts.email_confirmed_at IS NOT NULL")
  }

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  after_update :after_status_changed, if: :saved_change_to_status?

  enum status: %i{pending approved declined spam}

  validates :organization_company_name, :ambassador_since_year, :job_title, :bio,
    presence: true

  has_many :exports, foreign_key: :account_id, dependent: :destroy
  has_many :regional_pitch_events

  has_many :messages, as: :sender
  has_many :multi_messages, as: :sender

  delegate :submitted?,
           :candidate_id,
           :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
    end
  end

  def self.link_types
    %i{twitter facebook instagram snapchat whatsapp web}
  end

  def self.link_type_placeholders
    {
      placeholder_twitter: "@username",
      placeholder_facebook: "https://facebook.com/page-url",
      placeholder_instagram: "@username",
      placeholder_snapchat: "@username",
      placeholder_whatsapp: "+52 1 33 23 10 69 05",
      placeholder_web: "https://www.example.com",
    }
  end

  def links
    Links.new(self[:links])
  end

  def background_check_complete?
    country != "US" or !!background_check && background_check.clear?
  end

  def requires_background_check?
    country == "US" and
      not background_check_complete?
  end

  def profile_complete?
    bio_complete?
  end

  def bio_complete?
    not bio.blank?
  end

  def region_name
    return unless Country[country]

    if country == "US"
      Country[country].states.fetch(state_province) { {} }['name']
    else
      Country[country].name
    end
  end

  def onboarded?
    account.email_confirmed? and
      approved? and
        location_confirmed? and
          background_check_complete?
  end

  def authenticated?
    true
  end

  def scope_name
    "regional_ambassador"
  end

  private
  def after_status_changed
    AmbassadorMailer.public_send(status, account).deliver_later

    if approved?
      SubscribeEmailListJob.perform_later(
        account.email, account.full_name, "REGIONAL_AMBASSADOR_LIST_ID"
      )
    end
  end

  class Links
    include Enumerable

    def initialize(links)
      @links = Array(links)
    end

    def each(&block)
      @links.each { |link| block.call(Link.new(link)) }
    end

    class Link
      def initialize(link)
        @link = link
      end

      def icon
        case type
        when "twitter"
          'twitter-square'
        end
      end

      def url
        case type
        when "twitter"
          "https://twitter.com/#{@link["value"]}"
        end
      end

      def value
        case type
        when "twitter"
          "@#{@link["value"]}"
        end
      end

      def type
        @link["type"]
      end
    end
  end
end
