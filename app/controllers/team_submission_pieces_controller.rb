class TeamSubmissionPiecesController < ApplicationController
  include Authenticated

  def show
    piece = SubmissionPiece.new(params[:id])
    contributor = SubmissionContributor.for(current_account)
    redirect_to contributor.path_for(piece, self)
  end

  private

  def current_scope
    current_account.scope_name
  end

  class SubmissionPiece
    attr_reader :name

    def initialize(piece_name)
      @name = piece_name
    end
  end

  class SubmissionContributor
    attr_reader :account

    def self.for(account)
      if account.student_profile.present?
        SubmissionContributorStudent.new(account)
      elsif account.mentor_profile.present?
        SubmissionContributorMentor.new(account)
      else
        SubmissionContributor.new(account)
      end
    end

    def initialize(account)
      @account = account
    end

    def path_for(piece, context)
      context.send("#{account.scope_name}_dashboard_path")
    end
  end

  class SubmissionContributorStudent < SubmissionContributor
    def path_for(piece, context)
      if account.teams.current.any?
        submission = account.teams.current.last.submission

        if submission.present?
          context.send(
            :edit_student_team_submission_path,
            submission,
            piece: piece.name
          )
        else
          context.send(:new_student_team_submission_path)
        end
      else
        context.send(:new_student_team_submission_path)
      end
    end
  end

  class SubmissionContributorMentor < SubmissionContributor
    def path_for(piece, context)
      if account.teams.current.one?
        team = account.teams.current.last
        submission = team.submission

        if submission.present?
          context.send(
            :edit_mentor_team_submission_path,
            submission,
            piece: piece.name
          )
        else
          context.send(
            :new_mentor_team_submission_path,
            team_id: team.id
          )
        end
      else
        context.send(:new_mentor_team_submission_path)
      end
    end
  end
end
