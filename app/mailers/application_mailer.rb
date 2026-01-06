class ApplicationMailer < ActionMailer::Base
  require "MailchimpTransactional"

  default from: "Technovation Girls <mailer@technovationchallenge.org>"
  layout "mailer"

  private

  def render_email_template(template_name, template_content: [], merge_vars: [])
    # EmailTemplateRenderer.new(template_name:, template_content:, merge_vars:).call

    client = MailchimpTransactional::Client.new(ENV.fetch("MAIL_PASSWORD"))

    client.templates.render(
      {
        template_name:,
        template_content:,
        merge_vars: merge_vars.map { |name, content| {name:, content:} }
      }
    )["html"]
  end
end
