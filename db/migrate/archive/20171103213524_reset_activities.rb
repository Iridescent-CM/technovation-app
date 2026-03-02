class ResetActivities < ActiveRecord::Migration[5.1]
  def up
    PublicActivity::Activity.destroy_all

    Account.current.find_each do |account|
      account.create_activity(
        key: "account.create",
        created_at: account.created_at
      )

      if account.updated_at != account.created_at
        account.create_activity(
          key: "account.update",
          created_at: account.updated_at
        )
      end
    end

    Team.current.find_each do |team|
      team.create_activity(
        key: "team.create",
        created_at: team.created_at
      )

      if team.updated_at != team.created_at
        team.create_activity(
          key: "team.update",
          created_at: team.updated_at
        )
      end

      team.memberships.each do |membership|
        membership.member.create_activity(
          key: "account.join_team",
          recipient: membership.team,
          created_at: membership.created_at
        )
      end
    end
  end

  def down
    PublicActivity::Activity.destroy_all
  end
end
