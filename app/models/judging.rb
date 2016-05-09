class Judging
  class << self
    def open!(stage, date)
      reset_setting("#{stage}JudgingOpen", date)
    end

    def close!(stage, date)
      reset_setting("#{stage}JudgingClose", date)
    end

    private
    def reset_setting(key, value)
      setting.find_by(key: key).try(:destroy)
      setting.create!(key: key, value: value)
    end

    def setting
      Setting
    end
  end
end
