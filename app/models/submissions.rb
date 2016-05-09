class Submissions < DateBasedSetting
  class << self
    def open!(date)
      reset_setting('submissionOpen', date)
    end

    def open?
      (opening_date..closing_date).cover?(Date.today)
    end

    def close!(date)
      reset_setting('submissionClose', date)
    end

    def closing_date
      Date.parse(setting.find_by!(key: 'submissionClose').value)
    end

    def opening_date
      Date.parse(setting.find_by!(key: 'submissionOpen').value)
    end
  end
end
