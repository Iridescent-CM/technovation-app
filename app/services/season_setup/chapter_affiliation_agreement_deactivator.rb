module SeasonSetup
  class ChapterAffiliationAgreementDeactivator
    def call
      Document
        .where(signer_type: "LegalContact")
        .where("season_expires < '#{current_season}'")
        .update_all(active: false)
    end

    private

    def current_season
      Season.current.year
    end
  end
end
