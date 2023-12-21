class MissingParticipantSearch
  include ActiveModel::Model

  attr_accessor :first_name, :last_name, :email

  def attributes
    {
      first_name: first_name,
      last_name: last_name,
      email: email
    }.with_indifferent_access
  end
end
