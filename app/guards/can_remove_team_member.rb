module CanRemoveTeamMember
  def self.call(account, member, admin_ra = false)
    account.admin_profile or
      (account.regional_ambassador_profile and admin_ra) or
        member.onboarding? or
          account.id == member.account_id
  end
end
