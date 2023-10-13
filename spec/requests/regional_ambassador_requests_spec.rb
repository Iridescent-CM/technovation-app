require 'rails_helper'

RSpec.describe "Regional ambassador requests" do
  it "redirects all regional ambassador requests to chapter ambassador endpoints" do
    expect(get "/pending_regional_ambassador/dashboard").
      to redirect_to("/chapter_ambassador/dashboard")

    expect(patch "/regional_ambassador/profile_details_confirmation").
      to redirect_to("/chapter_ambassador/profile_details_confirmation")

    expect(put "/regional_ambassador/profile_details_confirmation").
      to redirect_to("/chapter_ambassador/profile_details_confirmation")

    expect(post "/regional_ambassador/profile_details_confirmation").
      to redirect_to("/chapter_ambassador/profile_details_confirmation")

    expect(get "/regional_ambassador/location_details").
      to redirect_to("/chapter_ambassador/location_details")

    expect(get "/regional_ambassador/current_location").
      to redirect_to("/chapter_ambassador/current_location")

    expect(patch "/regional_ambassador/location").
      to redirect_to("/chapter_ambassador/location")

    expect(put "/regional_ambassador/location").
      to redirect_to("/chapter_ambassador/location")

    expect(post "/regional_ambassador/location").
      to redirect_to("/chapter_ambassador/location")

    expect(get "/regional_ambassador/dashboard").
      to redirect_to("/chapter_ambassador/dashboard")

    expect(get "/regional_ambassador/data_analyses/:id").
      to redirect_to("/chapter_ambassador/data_analyses/:id")

    expect(get "/regional_ambassador/profile/edit").
      to redirect_to("/chapter_ambassador/profiles/edit")

    expect(get "/regional_ambassador/profile").
      to redirect_to("/chapter_ambassador/profile")

    expect(patch "/regional_ambassador/profile").
      to redirect_to("/chapter_ambassador/profile")

    expect(put "/regional_ambassador/profile").
      to redirect_to("/chapter_ambassador/profile")

    expect(get "/regional_ambassador/introduction/edit").
      to redirect_to("/chapter_ambassador/introduction/edit")

    expect(patch "/regional_ambassador/introduction").
      to redirect_to("/chapter_ambassador/introduction")

    expect(put "/regional_ambassador/introduction").
      to redirect_to("/chapter_ambassador/introduction")

    expect(get "/regional_ambassador/job_statuses/:id").
      to redirect_to("/chapter_ambassador/job_statuses/:id")

    expect(post "/regional_ambassador/saved_searches").
      to redirect_to("/chapter_ambassador/saved_searches")

    expect(get "/regional_ambassador/saved_searches/:id").
      to redirect_to("/chapter_ambassador/saved_searches/:id")

    expect(patch "/regional_ambassador/saved_searches/:id").
      to redirect_to("/chapter_ambassador/saved_searches/:id")

    expect(put "/regional_ambassador/saved_searches/:id").
      to redirect_to("/chapter_ambassador/saved_searches/:id")

    expect(delete "/regional_ambassador/saved_searches/:id").
      to redirect_to("/chapter_ambassador/saved_searches/:id")

    expect(get "/regional_ambassador/accounts/:id").
      to redirect_to("/chapter_ambassador/participants/:id")

    expect(get "/regional_ambassador/participants").
      to redirect_to("/chapter_ambassador/participants")

    expect(get "/regional_ambassador/participants/:id/edit").
      to redirect_to("/chapter_ambassador/participants/:id/edit")

    expect(get "/regional_ambassador/participants/:id").
      to redirect_to("/chapter_ambassador/participants/:id")

    expect(patch "/regional_ambassador/participants/:id").
      to redirect_to("/chapter_ambassador/participants/:id")

    expect(put "/regional_ambassador/participants/:id").
      to redirect_to("/chapter_ambassador/participants/:id")

    expect(get "/regional_ambassador/participant_sessions/:id").
      to redirect_to("/chapter_ambassador/participant_sessions/:id")

    expect(delete "/regional_ambassador/participant_sessions/:id").
      to redirect_to("/chapter_ambassador/participant_sessions/:id")

    expect(post "/regional_ambassador/student_conversions").
      to redirect_to("/chapter_ambassador/student_conversions")

    expect(post "/regional_ambassador/mentor_to_judge_conversions").
      to redirect_to("/chapter_ambassador/mentor_to_judge_conversions")

    expect(get "/regional_ambassador/missing_participant_search/new").
      to redirect_to("/chapter_ambassador/missing_participant_searches/new")

    expect(get "/regional_ambassador/missing_participant_search").
      to redirect_to("/chapter_ambassador/missing_participant_search")

    expect(post "/regional_ambassador/missing_participant_search").
      to redirect_to("/chapter_ambassador/missing_participant_search")

    expect(get "/regional_ambassador/missing_participant_locations/:id/edit").
      to redirect_to("/chapter_ambassador/missing_participant_locations/:id/edit")

    expect(patch "/regional_ambassador/missing_participant_locations/:id").
      to redirect_to("/chapter_ambassador/missing_participant_locations/:id")

    expect(put "/regional_ambassador/missing_participant_locations/:id").
      to redirect_to("/chapter_ambassador/missing_participant_locations/:id")

    expect(get "/regional_ambassador/teams").
      to redirect_to("/chapter_ambassador/teams")

    expect(get "/regional_ambassador/teams/:id").
      to redirect_to("/chapter_ambassador/teams/:id")

    expect(get "/regional_ambassador/team_submissions").
      to redirect_to("/chapter_ambassador/team_submissions")

    expect(get "/regional_ambassador/team_submissions/:id").
      to redirect_to("/chapter_ambassador/team_submissions/:id")

    expect(post "/regional_ambassador/team_memberships").
      to redirect_to("/chapter_ambassador/team_memberships")

    expect(delete "/regional_ambassador/team_memberships/:id").
      to redirect_to("/chapter_ambassador/team_memberships/:id")

    expect(get "/regional_ambassador/activities").
      to redirect_to("/chapter_ambassador/activities")

    expect(patch "/regional_ambassador/export_downloads/:id").
      to redirect_to("/chapter_ambassador/export_downloads/:id")

    expect(put "/regional_ambassador/export_downloads/:id").
      to redirect_to("/chapter_ambassador/export_downloads/:id")

    expect(get "/regional_ambassador/profile_image_upload_confirmation").
      to redirect_to("/chapter_ambassador/profile_image_upload_confirmation")

    expect(post "/regional_ambassador/background_checks").
      to redirect_to("/chapter_ambassador/background_checks")

    expect(get "/regional_ambassador/background_checks/new").
      to redirect_to("/chapter_ambassador/background_checks/new")

    expect(get "/regional_ambassador/background_checks/:id").
      to redirect_to("/chapter_ambassador/background_checks/:id")

    expect(get "/regional_ambassador/events").
      to redirect_to("/chapter_ambassador/regional_pitch_events")

    expect(post "/regional_ambassador/events").
      to redirect_to("/chapter_ambassador/regional_pitch_events")

    expect(get "/regional_ambassador/events/new").
      to redirect_to("/chapter_ambassador/regional_pitch_events/new")

    expect(get "/regional_ambassador/events/:id/edit").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id/edit")

    expect(get "/regional_ambassador/events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(patch "/regional_ambassador/events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(put "/regional_ambassador/events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(delete "/regional_ambassador/events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(get "/regional_ambassador/regional_pitch_events").
      to redirect_to("/chapter_ambassador/regional_pitch_events")

    expect(post "/regional_ambassador/regional_pitch_events").
      to redirect_to("/chapter_ambassador/regional_pitch_events")

    expect(get "/regional_ambassador/regional_pitch_events/new").
      to redirect_to("/chapter_ambassador/regional_pitch_events/new")

    expect(get "/regional_ambassador/regional_pitch_events/:id/edit").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id/edit")

    expect(get "/regional_ambassador/regional_pitch_events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(patch "/regional_ambassador/regional_pitch_events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(put "/regional_ambassador/regional_pitch_events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(delete "/regional_ambassador/regional_pitch_events/:id").
      to redirect_to("/chapter_ambassador/regional_pitch_events/:id")

    expect(get "/regional_ambassador/printable_scores/:id").
      to redirect_to("/chapter_ambassador/printable_scores/:id")

    expect(post "/regional_ambassador/event_team_list_exports").
      to redirect_to("/chapter_ambassador/event_team_list_exports")

    expect(post "/regional_ambassador/event_judge_list_exports").
      to redirect_to("/chapter_ambassador/event_judge_list_exports")

    expect(delete "/regional_ambassador/judge_assignments").
      to redirect_to("/chapter_ambassador/judge_assignments")

    expect(post "/regional_ambassador/judge_assignments").
      to redirect_to("/chapter_ambassador/judge_assignments")

    expect(post "/regional_ambassador/event_assignments").
      to redirect_to("/chapter_ambassador/event_assignments")

    expect(delete "/regional_ambassador/event_assignments").
      to redirect_to("/chapter_ambassador/event_assignments")

    expect(get "/regional_ambassador/possible_event_attendees").
      to redirect_to("/chapter_ambassador/possible_event_attendees")

    expect(get "/regional_ambassador/judge_list").
      to redirect_to("/chapter_ambassador/judge_list")

    expect(get "/regional_ambassador/team_list").
      to redirect_to("/chapter_ambassador/team_list")

    expect(get "/regional_ambassador/scores").
      to redirect_to("/chapter_ambassador/scores")

    expect(get "/regional_ambassador/scores/:id").
      to redirect_to("/chapter_ambassador/scores/:id")

    expect(get "/regional_ambassador/score_details/:id").
      to redirect_to("/chapter_ambassador/score_details/:id")

    expect(get "/regional_ambassador/judges").
      to redirect_to("/chapter_ambassador/judges")

    expect(get "/regional_ambassador/messages").
      to redirect_to("/chapter_ambassador/messages")

    expect(post "/regional_ambassador/messages").
      to redirect_to("/chapter_ambassador/messages")

    expect(get "/regional_ambassador/messages/new").
      to redirect_to("/chapter_ambassador/messages/new")

    expect(get "/regional_ambassador/messages/:id/edit").
      to redirect_to("/chapter_ambassador/messages/:id/edit")

    expect(get "/regional_ambassador/messages/:id").
      to redirect_to("/chapter_ambassador/messages/:id")

    expect(patch "/regional_ambassador/messages/:id").
      to redirect_to("/chapter_ambassador/messages/:id")

    expect(put "/regional_ambassador/messages/:id").
      to redirect_to("/chapter_ambassador/messages/:id")

    expect(delete "/regional_ambassador/messages/:id").
      to redirect_to("/chapter_ambassador/messages/:id")

    expect(get "/regional_ambassador/multi_messages").
      to redirect_to("/chapter_ambassador/multi_messages")

    expect(post "/regional_ambassador/multi_messages").
      to redirect_to("/chapter_ambassador/multi_messages")

    expect(get "/regional_ambassador/multi_messages/new").
      to redirect_to("/chapter_ambassador/multi_messages/new")

    expect(get "/regional_ambassador/multi_messages/:id/edit").
      to redirect_to("/chapter_ambassador/multi_messages/:id/edit")

    expect(get "/regional_ambassador/multi_messages/:id").
      to redirect_to("/chapter_ambassador/multi_messages/:id")

    expect(patch "/regional_ambassador/multi_messages/:id").
      to redirect_to("/chapter_ambassador/multi_messages/:id")

    expect(put "/regional_ambassador/multi_messages/:id").
      to redirect_to("/chapter_ambassador/multi_messages/:id")

    expect(delete "/regional_ambassador/multi_messages/:id").
      to redirect_to("/chapter_ambassador/multi_messages/:id")

    expect(post "/regional_ambassador/message_deliveries").
      to redirect_to("/chapter_ambassador/message_deliveries")
  end
end
