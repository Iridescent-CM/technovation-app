class StudentMailer < ApplicationMailer
  def parental_consent_rejected(account)
    @name = account.first_name

    I18n.with_locale(account.locale) do
      mail to: account.email
    end
  end

  def chapter_assigned(account)
    @first_name = account.first_name
    @chapter_name = account.current_chapter.name

    I18n.with_locale(account.locale) do
      mail to: account.email
    end
  end
end
