class TechnicalChecklist < ActiveRecord::Base
  belongs_to :team_submission

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

  def completed?
    total_technical_components >= 4 and
      total_database_components >= 1 and
        total_mobile_components >= 1 and
          completed_pics_of_process?
  end

  private
  def total_technical_components
    %i{
      used_strings
      used_numbers
      used_variables
      used_lists
      used_booleans
      used_loops
      used_conditionals
    }.reject { |m| send(m).blank? }.count
  end

  def total_database_components
    %i{
      used_local_db
      used_external_db
    }.reject { |m| send(m).blank? }.count
  end

  def total_mobile_components
    %i{
      used_location_sensor
      used_camera
      used_accelerometer
      used_sms_phone
      used_sound
      used_sharing
      used_clock
      used_canvas
    }.reject { |m| send(m).blank? }.count
  end

  def completed_pics_of_process?
    paper_prototype and event_flow_chart and team_submission.screenshots.count >= 2
  end
end
