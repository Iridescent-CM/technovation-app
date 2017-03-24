class MessageMailer < ApplicationMailer
  def send_message(message, recipient = message.recipient)
    @body = message.body
    @name = recipient.full_name
    @sender_name = message.sender.full_name
    @sender_email = message.sender.email
    @regarding_name = message.regarding_name

    if message.regarding
      @regarding_link_text = "View the full details of the event"

      @regarding_url = public_send(
        "#{recipient.type_name}_#{message.regarding_type.underscore}_url",
        message.regarding
      )
    end

    I18n.with_locale(recipient.locale) do
      mail to: recipient.email,
           from: message.sender.email,
           subject: message.subject
    end
  end
end
