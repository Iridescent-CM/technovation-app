module CheckrApiClient
  class BackgroundCheckInvitationValidator
    def initialize(account:)
      @account = account
    end

    def call
      if account.last_name.length < 2
        return Result.new(
          error?: true,
          error_message: "Checkr requires last name to contain at least 2 alpha characters. Please edit your last name."
        )
      end

      if account.is_chapter_ambassador?
        requires_background_check_invitation = account.chapter_ambassador_profile.requires_background_check?
      elsif account.is_a_mentor?
        requires_background_check_invitation = account.mentor_profile.requires_background_check_invitation?
      end

      Result.new(requires_background_check_invitation?: requires_background_check_invitation)
    end

    private

    Result = Struct.new(:requires_background_check_invitation?, :error?, :error_message, keyword_init: true)

    attr_reader :account, :current_profile_type

  end
end
