require 'ostruct'

class SelectSurvey


  def initialize(user, setting)
    @user = user
    @period = self.class.select_period(setting)
  end

  def link
    @period? self.class.data[@user.role][@period] : ""
  end

  def self.select_period(setting)
    case
      when setting.pre_program_survey_visible?
        :pre
      when setting.post_program_survey_visible?
        :post
      else
        :none
      end
  end

  def self.data
    SurveyData
  end

  SurveyData = OpenStruct.new({
    :student => OpenStruct.new({
                pre: "https://www.surveymonkey.com/s/683JH6K",
                post: "http://rockman.co1.qualtrics.com/SE/?SID=SV_0cankgvZeqVcy3P"
              }),
    :mentor => OpenStruct.new({
                pre: "https://www.surveymonkey.com/s/6GLCHTB",
                post: "http://rockman.co1.qualtrics.com/SE/?SID=SV_bjRy3xD4O81l6i9"
              }),
    :coach => OpenStruct.new({
                pre: "https://www.surveymonkey.com/s/SV2FST7",
                post: "http://rockman.co1.qualtrics.com/SE/?SID=SV_cN166tnJClpa7jf"
              })
    })

end
