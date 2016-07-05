require './lib/legacy/models/legacy_model'

module Legacy
  class User < LegacyModel
    enum role: [:student, :mentor, :coach, :judge]

    def parent_name
      [parent_first_name, parent_last_name].join(" ")
    end
  end
end
