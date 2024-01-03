module Mailchimp
  class MailingList
    def initialize(
      client_constructor: Gibbon::Request,
      api_key: ENV.fetch("MAILCHIMP_API_KEY"),
      list_id: ENV.fetch("MAILCHIMP_LIST_ID"),
      enabled: ENV.fetch("ENABLE_MAILCHIMP", false),
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @list = client_constructor.new(api_key: api_key).lists(list_id)
      @list_id = list_id
      @enabled = enabled
      @logger = logger
      @error_notifier = error_notifier
    end

    def subscribe(account:, profile_type: "")
      handle("subscribe #{account.email} to list: #{list_id}") do
        list.members.create(
          body: body_for(account, profile_type, {status: "subscribed"})
        )
      end
    end

    def add_profile_type_to_account(profile_type:, account:)
      handle("add profile type #{profile_type} to #{account.email} on list: #{list_id}") do
        list.members(subscriber_hash(account.email)).tags.create(
          body: {tags: [{name: profile_type, status: "active"}]}
        )
      end
    end

    def update(account:, currently_subscribed_as: "")
      if currently_subscribed_as.blank?
        currently_subscribed_as = account.email
      end

      handle("update #{currently_subscribed_as} on list: #{list_id}") do
        list.members(subscriber_hash(currently_subscribed_as)).update(
          body: body_for(account)
        )
      end
    end

    def delete(email_address:)
      handle("delete #{email_address} from list: #{list_id}") do
        list.members(subscriber_hash(email_address)).delete
      end
    end

    private

    attr_reader :list, :list_id, :enabled, :logger, :error_notifier

    def handle(message, &block)
      if enabled
        begin
          block.call
        rescue Gibbon::MailChimpError => e
          error = "[MAILCHIMP] #{e.message}"

          logger.error(error)
          error_notifier.notify(error)
        end
      else
        logger.info "[MAILCHIMP DISABLED] Trying to #{message}"
      end
    end

    def body_for(account, profile_type = "", additonal_options = {})
      {
        email_address: account.email,
        merge_fields: {
          BIRTHYEAR: account.date_of_birth&.year || "",
          COUNTRY: account.country.to_s,
          FNAME: account.first_name.to_s,
          LNAME: account.last_name.to_s,
          NAME: account.full_name.to_s,
          PARENTNAME: account.student_profile&.parent_guardian_name.to_s,
          PARENTREG: account.parent_registered?.to_s
        }
      }.merge(location_for(account))
        .merge(tags_for(profile_type))
        .merge(additonal_options)
    end

    def location_for(account)
      if account.latitude.present? && account.longitude.present?
        {
          location: {
            latitude: account.latitude,
            longitude: account.longitude
          }
        }
      else
        {}
      end
    end

    def tags_for(profile_type)
      profile_type.present? ? {tags: [profile_type]} : {}
    end

    def subscriber_hash(email_address)
      Digest::MD5.hexdigest(email_address.downcase)
    end
  end
end
