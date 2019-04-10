class AttendeesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name,
    :scope,
    :status,
    :human_status,
    :status_explained,
    :selected,
    :links,
    :assignments,
    :division,
    :submission,
    :email,
    :persisted?
end