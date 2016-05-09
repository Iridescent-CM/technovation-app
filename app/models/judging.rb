class Judging < DateBasedSetting
  class << self
    def open!(stage, date)
      reset_setting("#{stage}JudgingOpen", date)
    end

    def close!(stage, date)
      reset_setting("#{stage}JudgingClose", date)
    end
  end
end
