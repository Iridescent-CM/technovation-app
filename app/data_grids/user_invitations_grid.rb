class UserInvitationsGrid
  include Datagrid

  scope do
    UserInvitation.order(created_at: :desc)
  end

  column :profile_type, header: "Registration Type", mandatory: true do |registration_invite|
    case registration_invite.profile_type
    when "parent_student"
      "Parent"
    else
      registration_invite.profile_type.titleize
    end
  end

  column :email, header: "Invitee", mandatory: true, html: true do |registration_invite|
    if registration_invite.name.present?
      "#{registration_invite.name} - #{registration_invite.email}"
    else
      registration_invite.email
    end
  end

  column :status, mandatory: true do |registration_invite|
    registration_invite.status.capitalize
  end

  column :account, mandatory: true, html: true do |registration_invite|
    if registration_invite.account.present?
      link_to(
        registration_invite.account.full_name,
        admin_participant_path(registration_invite.account)
      )
    else
      "-"
    end
  end

  column :invited_by, header: "Invited By", mandatory: true, html: true do |registration_invite|
    if registration_invite.invited_by.present?
      link_to(
        registration_invite.invited_by.full_name,
        admin_participant_path(registration_invite.invited_by)
      )
    else
      "-"
    end
  end

  column :actions, mandatory: true, html: true do |registration_invite|
    render "admin/user_invitations/actions", registration_invite: registration_invite
  end

  filter :profile_type,
    :enum,
    header: "Registration Type",
    select: UserInvitation::PROFILE_TYPES

  filter :status,
    :enum,
    header: "Invite Status",
    select: UserInvitation.statuses.transform_keys(&:capitalize)
end
