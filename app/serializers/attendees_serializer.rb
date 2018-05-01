class AttendeesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
    :name,
    :scope,
    :status,
    :human_status,
    :status_explained,
    :selected,
    :links,
    :assignments,
    :division,
    :submission,
    :email
end