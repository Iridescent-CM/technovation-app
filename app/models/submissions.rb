class Submissions
  class << self
    def open!(date)
      setting.find_or_create_by({
        key: 'submissionOpen',
        value: date
      })
    end

    def close!(date)
      setting.find_or_create_by({
        key: 'submissionClose',
        value: date
      })
    end

    def closing_date
      Date.parse(setting.find_by!(key: 'submissionClose').value)
    end

    private
    def setting
      Setting
    end
  end
end
