class Certificate < ApplicationRecord
  include Seasoned

  enum cert_type: CERTIFICATE_TYPES

  belongs_to :account
  belongs_to :team, required: false

  mount_uploader :file, FileProcessor

  scope :judge_types, -> {
    where(cert_type: JUDGE_CERTIFICATE_TYPES.keys)
  }

  scope :student_types, -> {
    where(cert_type: STUDENT_CERTIFICATE_TYPES.keys)
  }

  scope :mentor_types, -> {
    where(cert_type: MENTOR_CERTIFICATE_TYPES.keys)
  }

  scope :for_team, ->(team) {
    where(team: team)
  }

  scope :previous_certificates, -> {
    where.not(season: Season.current.year)
  }

  def self.highest_awarded_student_certs_for_previous_seasons
    past
      .student_certs_ordered_by_highest_awarded
      .group_by { |cert| cert.season }
      .map { |_, certs| certs.first }
  end

  def self.highest_awarded_student_cert_for_current_season
    current.student_certs_ordered_by_highest_awarded.first
  end

  def self.student_certs_ordered_by_highest_awarded
    all.sort do |cert_a, cert_b|
      if cert_a.cert_type == "semifinalist" && (cert_b.cert_type == "quarterfinalist" || cert_b.cert_type == "participation") ||
          cert_a.cert_type == "quarterfinalist" && cert_b.cert_type == "participation"
        -1
      elsif cert_a.cert_type == "participation" && (cert_b.cert_type == "quarterfinalist" || cert_b.cert_type == "semifinalist") ||
          cert_a.cert_type == "quarterfinalist" && cert_b.cert_type == "semifinalist"
        1
      else
        0
      end
    end
  end

  def description
    title = cert_type.humanize.titleize

    if team.present?
      "#{title} Certificate for #{team.name}"
    else
      "#{title} Certificate"
    end
  end
end
