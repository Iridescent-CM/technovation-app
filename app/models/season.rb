class Season
  class << self
    def open!(year)
      setting.find_by(key: 'year').try(:destroy)
      setting.create!(key: 'year', value: year.to_s)
    end

    private
    def setting
      Setting
    end
  end
end
