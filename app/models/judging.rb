class Judging
  class << self
    def open!(stage, date)
      setting.find_or_create_by!({
        key: "#{stage}JudgingOpen",
        value: date
      })
    end

    def close!(stage, date)
      setting.find_or_create_by!({
        key: "#{stage}JudgingClose",
        value: date
      })
    end

    private
    def setting
      Setting
    end
  end
end
