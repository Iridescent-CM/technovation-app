class DateBasedSetting
  class << self
    def open!(*args, &block)
      raise "Subclass #{name} must implement .open!"
    end

    def close!(*args, &block)
      raise "Subclass #{name} must implement .close!"
    end

    private
    def reset_setting(key, value)
      attrs = { key: key.to_s, value: value.to_s }

      if setting_record = setting.find_by(key: key)
        setting_record.update_attributes(attrs)
      else
        setting.create!(attrs)
      end
    end

    def setting
      Setting
    end
  end
end
