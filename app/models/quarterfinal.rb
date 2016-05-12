class Quarterfinal
  class << self
    def open!(open: Date.today, close: Date.today + 1)
      setting.reset("quarterfinalJudgingOpen", open)
      setting.reset("quarterfinalJudgingClose", close)
    end

    def close!(close: Date.today - 1, open: Date.today - 2)
      open!(open: open, close: close)
    end

    private
    def setting
      Setting
    end
  end
end
