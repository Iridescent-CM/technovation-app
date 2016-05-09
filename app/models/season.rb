class Season < DateBasedSetting
  class << self
    def open!(year)
      reset_setting(:year, year)
    end
  end
end
