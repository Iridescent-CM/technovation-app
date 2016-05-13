class Semifinal
  class << self
    def open!(open: Date.today, close: Date.today + 1)
      setting.reset("semifinalJudgingOpen", open)
      setting.reset("semifinalJudgingClose", close)
    end

    def close!(close: Date.today - 1, open: Date.today - 2)
      open!(open: open, close: close)
    end

    def after_close?
      date = setting.get_date("semifinalJudgingClose")
      Date.today > date
    end

    private
    def setting
      Setting
    end
  end
end
