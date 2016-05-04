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

    private
    def setting
      Setting
    end
  end
end
