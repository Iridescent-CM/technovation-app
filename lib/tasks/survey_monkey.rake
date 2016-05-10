namespace :survey_monkey do
  namespace :surveys do 
    task :list => :environment do 
      data = SurveyMonkey.request('surveys','get_survey_list')
      survey_ids = data['data']['surveys'].map do |hash|
        hash['survey_id']
      end
      survey_ids.each do |survey_id|
        data = SurveyMonkey.request('surveys','get_survey_details'){ {:survey_id => survey_id} }
        collectors = SurveyMonkey.request('surveys','get_collector_list'){ {:survey_id => survey_id, :fields => [:url]} }
        collector_urls = collectors['data']['collectors'].select{|c| c['url']}.map{|c| URI(c['url']).path }
        puts "%s => %s | %s" % [data['data']['title']['text'], survey_id, collector_urls.join(', ')]
      end
    end
  end

  namespace :users do 
    task :update_responses => :environment do 
      User.roles.each do |key, value|
        survey_id = Rails.application.config.env[:surveys][:required][key][:id]
        data = SurveyMonkey.request('surveys','get_respondent_list') { {:survey_id => survey_id, :fields => [:custom_id]} }
        respondents = data['data']['respondents']
        ids = respondents.reject{|r| r['custom_id'].blank? }.map{|respondent| respondent['custom_id'] }
        User.where(:is_survey_done => false).where(:id => ids).update_all(:is_survey_done => true) if ids.any?
      end
    end
  end
end
