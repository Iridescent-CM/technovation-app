class Attendees
  include Enumerable

  def self.for(
    type:,
    context:,
    query: "",
    expand_search: false,
    ambassador: NullChapterAmbassador.new,
    event: NullEvent.new,
    exclude_event_attendees: false
  )
    model = type.to_s.camelize.constantize
    table_name = model.table_name
    sort_column = model.sort_column

    if ambassador.present?
      scope = model.live_event_eligible(event)

      if expand_search
        records = scope.by_query(query)
      else
        records = scope.in_region(ambassador)
      end
    else
      assoc = type.to_s.underscore.downcase.pluralize
      records = event.send(assoc)
    end

    if records.empty? and
        type.to_s === "account" and
          not query.blank?
      table_name = "user_invitations"
      sort_column = :email
      records = UserInvitation.judge.by_query(query)

      if records.empty?
        invite = UserInvitation.new(
          profile_type: :judge,
          email: query,
        )

        if invite.valid?
          records = [invite]
        end
      end
    end

    if records.is_a?(Array)
      records = records
        .sort { |a, b|
          a.public_send(sort_column).downcase <=> b.public_send(sort_column).downcase
        }.to_a
    else
      records = records.order(Arel.sql("lower(unaccent(#{table_name}.#{sort_column}))")).to_a
    end

    if exclude_event_attendees
      records = records.reject { |attendee| attendee.in_event?(event) }
    end

    if type.to_s === "account" and not query.blank? and
      !records.select { |attendee| attendee.email == query }.any?
          invite = UserInvitation.new(
            profile_type: :judge,
            email: query,
          )

          if invite.valid?
            records.unshift(invite)
          end
    end

    new(records, event, context)
  end

  attr_reader :event, :context

  def initialize(records, event, context)
    @records = records
    @context = context
    @event = event
  end

  def each(&block)
    @records.each do |record|
      block.call(Attendee.new(record, event, context))
    end
  end
end
