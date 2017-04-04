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

  def total_verified
    total_coding_verified +
      total_db_verified +
        total_mobile_verified +
          total_process_verified
  end

  def total_coding_verified
    calculate_total_verified(
      technical_components,
      points_each: 1,
      points_max:  4
    )
  end

  def total_db_verified
    calculate_total_verified(
      database_components,
      points_each: 1,
      points_max: 1
    )
  end

  def total_mobile_verified
    calculate_total_verified(
      mobile_components,
      points_each: 2,
      points_max: 2
    )
  end

  def total_process_verified
    if %i{paper_prototype
          event_flow_chart
          paper_prototype_verified
          event_flow_chart_verified}.all? { |a| self[a] } and
         team_submission.screenshots.count >= 2
      3
    else
      0
    end
  end

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
            a.match(/_verified/) or
              !send(a)
    }.map { |a| Item.new(self, a) }
  end

  private
  def calculate_total_verified(components, options)
    components.reduce(0) do |sum, aspect|
      if sum == options[:points_max]
        sum
      elsif self[aspect] and
          not self["#{aspect}_explanation"].blank? and
            self["#{aspect}_verified"]
        sum += options[:points_each]
      else
        sum
      end
    end
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
  end
end
