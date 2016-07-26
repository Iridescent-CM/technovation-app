require "./app/technovation/profile_completion/step"
require "./app/technovation/profile_completion/link"

class ProfileCompletionSteps
  @@steps = []

  def self.register_step(config = {})
    links = config.fetch(:links) { [] }.map do |link_config|
      ProfileCompletion::Link.new(link_config.fetch(:text_path),
                                  link_config.fetch(:url),
                                  link_config.fetch(:link_options) { {} },
                                  link_config.fetch(:tag_options) { {} })
    end

    @@steps << ProfileCompletion::Step.new(config.fetch(:id),
                                           config.fetch(:label_path),
                                           config.fetch(:pre_requisites) { [] },
                                           config.fetch(:complete_condition),
                                           links)
  end

  def self.registered_steps
    @@steps
  end
end

ProfileCompletionSteps.register_step({
  id: :pps,
  label_path: "views.profile_requirements.pre_program_survey.label",
  complete_condition: :pre_survey_completed?,
  links: [
    {
      text_path: "views.profile_requirements.pre_program_survey.links.survey.text",
      url: ENV.fetch("PRE_PROGRAM_SURVEY") { "#" },
    },
    {
      text_path: "views.profile_requirements.pre_program_survey.links.mark_complete.text",
      url: [:student_account_path, { pre_survey_completed_at: Time.current }],
      link_options: {
        postfix_path: "views.profile_requirements.pre_program_survey.links.mark_complete.post_text",
      },
      tag_options: {
        data: {
          method: :put,
        },
      },
    },
  ],
})

ProfileCompletionSteps.register_step({
  id: :pc,
  label_path: "views.profile_requirements.parental_consent.label",
  complete_condition: :parental_consent_signed?,
  links: [
    {
      text_path: "views.profile_requirements.parental_consent.links.resend.text",
      url: '#',
      tag_options: {
        data: {
          method: :post,
        },
      },
    },
  ],
})

ProfileCompletionSteps.register_step({
  id: :cjt,
  label_path: "views.profile_requirements.create_join_team.label",
  complete_condition: :is_on_team?,
  prerequisites: [:pps, :pc],
  links: [
    {
      text_path: "views.profile_requirements.create_join_team.links.create.text",
      url: :new_student_team_path,
    },
    {
      text_path: "views.profile_requirements.create_join_team.links.join.text",
      url: :new_student_team_search_path,
    },
  ],
})

ProfileCompletionSteps.register_step({
  id: :fm,
  label_path: "views.profile_requirements.find_mentor.label",
  complete_condition: :team_has_mentor?,
  prerequisites: [:pps, :pc, :cjt],
  links: [
    {
      text_path: "views.profile_requirements.find_mentor.links.browse.text",
      url: :student_mentor_search_path,
    },
  ],
})
