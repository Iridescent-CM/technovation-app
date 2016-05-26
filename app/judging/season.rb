class Season < DateBasedSetting
  class << self
    def open!(year = Date.today.year)
      reset_setting(:year, year)
    end
  end
end
