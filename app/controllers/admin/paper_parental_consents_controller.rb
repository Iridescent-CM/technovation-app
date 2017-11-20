module Admin
  class PaperParentalConsentsController < AdminController
    def create
      student = StudentProfile.find(params[:id])

      student.student_profile.update_columns(parent_guardian_name: "ON FILE",
                                             parent_guardian_email: "ON FILE")

      sql = ActiveRecord::Base.send(
        :sanitize_sql_array,
        [
          "UPDATE parental_consents
           SET (status, electronic_signature, created_at, updated_at)
             VALUES (?, ?, ?, ?)
               WHERE parental_consents.student_profile_id = ?",
         ParentalConsent.statuses[:signed],
         'ON FILE',
         Time.current,
         Time.current,
         student.id,
        ]
      )

      ActiveRecord::Base.connection.execute(sql)

      ParentalConsent.last.after_signed_student_actions

      redirect_to admin_profile_path(student.account),
        success: "#{student.full_name} has their paper parental consent on file."
    end
  end
end
