module ExportCertificates
  def self.call(submission_id)
    submission = TeamSubmission.includes(team: { memberships: { member: :account } }).find(submission_id)
    return unless submission.complete?

    puts "Generating certs for #{submission.app_name}"

    students = submission.team.students
    mentors = submission.team.mentors

    students.each do |student|
      student_data = {
        'Recipient Name' => student.full_name,
        'app name' => submission.app_name,
        'id' => student.account_id
      }
      FillPdfJob.perform_later(student_data, "completion")
    end

    mentors.each do |mentor|
      mentor_data = {
        'Recipient Name' => mentor.full_name,
        'Region Name' => "TODO",
        'id' => mentor.account_id
      }
      FillPdfJob.perform_later(mentor_data, "mentor")
    end

    puts Certificate.last.file_url
  end
end
