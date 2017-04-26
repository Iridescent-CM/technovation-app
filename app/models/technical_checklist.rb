class TechnicalChecklist < ActiveRecord::Base
  belongs_to :team_submission, touch: true

  mount_uploader :paper_prototype, ImageUploader
  mount_uploader :event_flow_chart, ImageUploader

  validate -> {
    attributes.keys.each do |k, v|
      claiming_use = send(k.sub('_explanation', ''))

      if claiming_use &&
          k.match(/explanation/) &&
            send(k).blank?
        errors.add(k, :blank)
      end
    end
  }

  validates :paper_prototype, :event_flow_chart,
    verify_cached_file: true

  def completed?
    total_technical_components >= 4 and
      total_database_components >= 1 and
        total_mobile_components >= 1 and
          completed_pics_of_process?
  end

  def technical_components
    %i{
      used_strings
      used_numbers
      used_variables
      used_lists
      used_booleans
      used_loops
      used_conditionals
    }
  end

  def database_components
    %i{
      used_local_db
      used_external_db
    }
  end

  def mobile_components
    %i{
      used_location_sensor
      used_camera
      used_accelerometer
      used_sms_phone
      used_sound
      used_sharing
      used_clock
      used_canvas
    }
  end

  def pics_of_process
    %i{
      paper_prototype
      event_flow_chart
    }
  end

  def checked_items
    attributes.reject { |a|
      a.match(/id$/) or
        a.match(/_at$/) or
          a.match(/_explanation/) or
            !send(a)
    }.map { |a| Item.new(self, a) }
  end

  def total_points
    total_technical_components +
      total_database_components +
        total_mobile_components +
          (completed_pics_of_process? ? 3 : 0)
  end

  def total_technical_components
    technical_components.reject { |m| send(m).blank? }.count
  end

  def total_database_components
    database_components.reject { |m| send(m).blank? }.count
  end

  def total_mobile_components
    mobile_components.reject { |m| send(m).blank? }.count
  end

  def completed_pics_of_process?
    paper_prototype and event_flow_chart and team_submission.screenshots.count >= 2
  end

  private
  class Item
    def initialize(tc, attribute)
      @tc = tc
      @attribute = attribute
    end

    def label
      if name.match(/prototype/) or name.match(/flow_chart/)
        @attribute[0].humanize
      else
        "We #{@attribute[0]}".humanize
      end
    end

    def name
      @attribute[0]
    end

    def value
      @attribute[1]
    end

    def explanation
      if name.match(/prototype/) or name.match(/flow_chart/)
        false
      else
        @tc.public_send("#{name}_explanation")
      end
    end

    def display
      # for paper prototype / event flow chart, which are image urls
      @tc.public_send(name)
    end

    def present?
      !!value
    end
  end
end
