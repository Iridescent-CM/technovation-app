require 'ostruct'

class SelectSurvey

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


  def initialize(user, submissions)
    @user = user
    @period = submissions.has_opened? ? :post : :pre
  end

  def link
    SurveyData[@user.role][@period]
  end
end
