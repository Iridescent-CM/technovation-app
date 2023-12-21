module CanRemoveTeamMember
  def self.call(account, member, admin_chapter_ambassador = false)
    account.admin_profile or
      (account.chapter_ambassador_profile and admin_chapter_ambassador) or
      member.onboarding? or
      account.id == member.account_id
  end
end
