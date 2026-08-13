class Certificate < ApplicationRecord
  include Seasoned

  enum :cert_type, CertificateTypes::CERTIFICATE_TYPES

  belongs_to :account
  belongs_to :team, required: false

  mount_uploader :file, FileProcessor

  JUDGE_LETTER_CERT_TYPES = %i[bronze_judge_letter silver_judge_letter gold_judge_letter].freeze

  scope :judge_types, -> {
    where(cert_type: CertificateTypes::JUDGE_CERTIFICATE_TYPES.keys)
  }

  scope :judge_certificates_and_letters, -> {
    where(cert_type: CertificateTypes::JUDGE_CERTIFICATE_TYPES.keys + JUDGE_LETTER_CERT_TYPES)
  }

  scope :student_types, -> {
    where(cert_type: CertificateTypes::STUDENT_CERTIFICATE_TYPES.keys)
  }

  scope :mentor_types, -> {
    where(cert_type: CertificateTypes::MENTOR_CERTIFICATE_TYPES.keys + [:mentor_letter])
  }

  scope :ambassador_types, -> {
    where(cert_type: CertificateTypes::AMBASSADOR_CERTIFICATE_TYPES.keys)
  }

  scope :letter_types, -> {
    where(cert_type: CertificateTypes::LETTER_OF_RECOGNITION_TYPES.keys)
  }

  scope :judge_letter_types, -> {
    where(cert_type: JUDGE_LETTER_CERT_TYPES)
  }

  scope :for_team, ->(team) {
    where(team: team)
  }

  scope :previous_certificates, -> {
    where.not(season: Season.current.year)
  }

  def self.highest_awarded_student_certs_for_previous_seasons
    past
      .preload(:team)
      .student_certs_ordered_by_highest_awarded
      .group_by { |cert| cert.season }
      .map { |_, certs| certs.first }
  end

  def self.highest_awarded_student_cert_for_current_season
    current.preload(:team).student_certs_ordered_by_highest_awarded.first
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
    if letter_type?
      letter_description
    else
      certificate_description
    end
  end

  def letter_type?
    CertificateTypes::LETTER_OF_RECOGNITION_TYPES.key?(cert_type.to_sym)
  end

  private

  def letter_description
    role = cert_type.sub("_letter", "").humanize.titleize

    if team.present?
      "Letter of Recognition (#{role}) for #{team.name}"
    else
      "Letter of Recognition (#{role})"
    end
  end

  def certificate_description
    title = cert_type.humanize.titleize

    if team.present?
      "#{title} Certificate for #{team.name}"
    else
      "#{title} Certificate"
    end
  end
end
