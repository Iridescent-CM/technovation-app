class UserInvitationsGrid
  include Datagrid

  scope do
    UserInvitation.includes(:account, :invited_by).order(created_at: :desc)
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

  column :email, header: "Invitee's Name", mandatory: true, html: false do |registration_invite|
    registration_invite.name
  end

  column :email, header: "Invitee's Email Address", mandatory: true, html: false do |registration_invite|
    registration_invite.email
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

  column :account, header: "Account Id", mandatory: true, html: false do |registration_invite|
    registration_invite.account&.id
  end

  column :invited_by, header: "Invited By", mandatory: true do |registration_invite|
    format(registration_invite.invited_by&.name) do |invited_by_name|
      if invited_by_name.present?
        link_to(
          invited_by_name,
          admin_participant_path(registration_invite.invited_by)
        )
      else
        "-"
      end
    end
  end

  column :invited_by_profile_type, header: "Invited By Profile Type" do |registration_invite|
    if registration_invite.invited_by&.is_admin?
      "Admin"
    elsif registration_invite.invited_by&.is_an_ambassador?
      "Chapter Ambassador"
    else
      "-"
    end
  end

  column :chapter, preload: [:chapter], html: true do |registration_invite|
    if registration_invite.chapter.present?
      link_to(
        registration_invite.chapter.organization_name,
        admin_chapter_path(registration_invite.chapter)
      )
    else
      "-"
    end
  end

  column :club, preload: [:club], html: true do |registration_invite|
    if registration_invite.club.present?
      link_to(
        registration_invite.club.name,
        admin_club_path(registration_invite.club)
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

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
