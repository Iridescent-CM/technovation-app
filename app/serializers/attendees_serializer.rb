class AttendeesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name,
    :scope,
    :status,
    :human_status,
    :status_explained,
    :selected,
    :links,
    :division,
    :submission,
    :email,
    :persisted?

  attribute :assignments do |obj|
    # ids are strings on the client side
    obj.assignments.map { |k, v|
      [k, v.map(&:to_s)]
    }.to_h
  end
end