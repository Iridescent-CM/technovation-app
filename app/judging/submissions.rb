class Submissions < DateBasedSetting
  class << self
    def open!(open: Date.today, close: nil)
      close ||= open + 1
      reset_setting('submissionOpen', open)
      reset_setting('submissionClose', close)
    end

    def open?
      (opening_date..closing_date).cover?(Date.today)
    end

    def close!(open: nil, close: Date.today - 1)
      close ||= open - 1
      open!(open: open, close: close)
    end

    def closing_date
      Date.parse(setting.find_by!(key: 'submissionClose').value)
    end

    def opening_date
      Date.parse(setting.find_by!(key: 'submissionOpen').value)
    end
  end
end
