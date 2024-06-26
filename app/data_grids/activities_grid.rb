class ActivitiesGrid
  include Datagrid

  self.batch_size = 10

  scope do
    PublicActivity::Activity.distinct
      .order("created_at desc")
  end

  column :avatar, html: true, mandatory: true do |activity|
    if !!activity.trackable
      image_tag activity.trackable.avatar_url, class: "thumbnail-xs"
    else
      "–"
    end
  end

  column :profile_type, mandatory: true do
    if !!trackable
      trackable.scope_name.humanize
    else
      "–"
    end
  end

  column :name, mandatory: true do |activity|
    if !!activity.trackable
      resource_name = activity.trackable.is_a?(Account) ?
        "participant" :
        "team"

      format(activity.trackable.name) do |value|
        link_to(
          value,
          send(
            "#{current_scope}_#{resource_name}_path",
            activity.trackable
          )
        )
      end
    else
      "–"
    end
  end

  column :activity, mandatory: true do
    HumanizedActivity.call(key, parameters)
  end

  column :target, mandatory: true do |activity|
    if !!activity.recipient
      resource_name = activity.recipient_type.underscore.singularize

      if resource_name == "account"
        resource_name = "participant"
      end

      format(activity.recipient.name) do |value|
        link_to activity.recipient.name,
          send("#{current_scope}_#{resource_name}_path", activity.recipient)
      end
    else
      "–"
    end
  end

  column :city do |activity|
    resource_name = activity.trackable_type
    resource_id = activity.trackable_id

    if resource_name == "Account"
      Account.find(resource_id).city
    elsif resource_name == "Team"
      Team.find(resource_id).city
    else
      "-"
    end
  end

  column :state do |activity|
    resource_name = activity.trackable_type
    resource_id = activity.trackable_id

    if resource_name == "Account"
      Account.find(resource_id).state
    elsif resource_name == "Team"
      Team.find(resource_id).state
    else
      "-"
    end
  end

  column :when, mandatory: true do |activity|
    format(activity.created_at) do |value|
      "#{time_ago_in_words(value)} ago"
    end
  end

  filter :trackable_type,
    :enum,
    header: "Filter by...",
    select: [
      "Account",
      "Team",
      "Submission"
    ] do |option|
      if option == "Submission"
        where(trackable_type: "Account")
          .where("key LIKE 'submission.%'")
      else
        where(trackable_type: option)
      end
    end

  filter :key,
    :enum,
    header: "Activity",
    select: [
      ["Account signed up", "account.create"],
      ["Account joined a team", "account.join_team"],
      ["Account left a team", "account.leave_team"],
      ["Account updated their profile", "account.update"],
      ["Account registered for season", "account.register_current_season"],
      ["Team was created", "team.create"],
      ["Team was updated", "team.update"],
      ["Team registered for season", "team.register_current_season"],
      ["Submission was created", "submission.create"],
      ["Submission was updated", "submission.update"]
    ]

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
