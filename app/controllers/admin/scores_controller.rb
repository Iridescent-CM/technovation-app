require 'will_paginate/array'

module Admin
  class ScoresController < AdminController
    def index
      params[:event] ||= "virtual"
      params[:junior_page] ||= 1
      params[:senior_page] ||= 1
      params[:per_page] ||= 25

      sort = case params.fetch(:sort) { "avg_score_desc" }
             when "avg_score_desc"
               "team_submissions.average_score DESC"
             when "avg_score_asc"
               "team_submissions.average_score ASC"
             when "team_name"
               "teams.name ASC"
             end

      @event = RegionalPitchEvent.find(params[:event])

      events = RegionalPitchEvent.eager_load(
        :divisions,
        :judges,
        regional_ambassador_profile: :account,
        teams: { team_submissions: :submission_scores }
      )

      virtual_event = Team::VirtualRegionalPitchEvent.new

      @events = [virtual_event] + events.sort_by { |e|
        FriendlyCountry.(e.regional_ambassador_profile.account)
      }

      @senior_teams = @event.teams.senior
        .order(sort)
        .page(params[:senior_page].to_i)
        .per_page(params[:per_page].to_i)

      @junior_teams = @event.teams.junior
        .order(sort)
        .page(params[:junior_page].to_i)
        .per_page(params[:per_page].to_i)

      if @senior_teams.empty?
        @senior_teams = @senior_teams.page(1)
      end

      if @junior_teams.empty?
        @junior_teams = @junior_teams.page(1)
      end
    end

    def show
      @team_submission = TeamSubmission.includes(
        team: :division,
        submission_scores: { judge_profile: :account }
      ).friendly.find(params[:id])

      @team = @team_submission.team

      @event = @team.selected_regional_pitch_event

      @scores = @team_submission.submission_scores
        .complete
        .includes(judge_profile: :account)
        .references(:accounts)
        .order("accounts.first_name")

      render "regional_ambassador/scores/show"
    end
  end
end
