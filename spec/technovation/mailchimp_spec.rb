require "rails_helper"

RSpec.describe Mailchimp::MailingList do
  let(:mailchimp_mailing_list) do
    Mailchimp::MailingList.new(
      client_constructor: mailchimp_client_constructor,
      api_key: mailchimp_api_key,
      list_id: mailchimp_list_id,
      enabled: mailchimp_enabled,
      logger: logger,
      error_notifier: error_notifier
    )
  end
  let(:mailchimp_client_constructor) { double("MailchimpClientConstructor") }
  let(:mailchimp_api_key) { "lll-mm-nnn-oo-ppp" }
  let(:mailchimp_list_id) { "12345abcde" }
  let(:mailchimp_enabled) { false }
  let(:logger) { double("Logger") }
  let(:error_notifier) { double("ErrorNotifier") }

  let(:mailchimp_client) { double("MailchimpClient") }
  let(:mailchimp_list) { double("MailchimpList") }

  let(:account) do
    double(
      Account,
      id: 1,
      email: "erin@example.com",
      full_name: "Erin Eclaire",
      first_name: "Erin",
      last_name: "Eclaire",
      date_of_birth: Date.parse("2005-05-05"),
      country: "US",
      latitude: 5000,
      longitude: 5000,
      parent_registered?: "false",
      student_profile: double("student_profile", parent_guardian_name: "Guardian Parento")
    )
  end

  before do
    allow(mailchimp_client_constructor).to receive(:new)
      .with(api_key: mailchimp_api_key)
      .and_return(mailchimp_client)

    allow(mailchimp_client).to receive(:lists)
      .with(mailchimp_list_id)
      .and_return(mailchimp_list)

    allow(logger).to receive(:error)
    allow(error_notifier).to receive(:notify)
  end

  describe "#subscribe" do
    context "when Mailchimp is enabled" do
      let(:mailchimp_enabled) { true }

      it "calls the appropriate Mailchimp method with the expected payload to subscribe the account" do
        expect(mailchimp_list).to receive_message_chain(:members, :create)
          .with(
            body: {
              email_address: account.email,
              location: {
                latitude: account.latitude,
                longitude: account.longitude
              },
              merge_fields: {
                BIRTHYEAR: account.date_of_birth.year,
                COUNTRY: account.country,
                FNAME: account.first_name,
                LNAME: account.last_name,
                NAME: account.full_name,
                PARENTNAME: account.student_profile.parent_guardian_name,
                PARENTREG: account.parent_registered?
              },
              status: "subscribed"
            }
          )

        mailchimp_mailing_list.subscribe(account: account)
      end

      context "when a profile_type is provided" do
        let(:profile_type) { "student" }

        it "includes a tag with the profile type" do
          expect(mailchimp_list).to receive_message_chain(:members, :create)
            .with(
              body: {
                email_address: account.email,
                location: {
                  latitude: account.latitude,
                  longitude: account.longitude
                },
                merge_fields: {
                  BIRTHYEAR: account.date_of_birth.year,
                  COUNTRY: account.country,
                  FNAME: account.first_name,
                  LNAME: account.last_name,
                  NAME: account.full_name,
                  PARENTNAME: account.student_profile.parent_guardian_name,
                  PARENTREG: account.parent_registered?
                },
                status: "subscribed",
                tags: [profile_type]
              }
            )

          mailchimp_mailing_list.subscribe(account: account, profile_type: profile_type)
        end
      end

      context "when there is a Mailchimp error" do
        let(:error_message) { "Out of stamps!" }

        before do
          allow(mailchimp_list).to receive_message_chain(:members, :create)
            .and_raise(Gibbon::MailChimpError, error_message)
        end

        it "logs the error message" do
          expect(logger).to receive(:error).with(/#{error_message}/)

          mailchimp_mailing_list.subscribe(account: account)
        end

        it "creates a notification via the error_notifier" do
          expect(error_notifier).to receive(:notify).with(/#{error_message}/)

          mailchimp_mailing_list.subscribe(account: account)
        end
      end
    end

    context "when Mailchimp is disabled" do
      let(:mailchimp_enabled) { false }

      it "logs a message" do
        expect(logger).to receive(:info)
          .with(/Trying to subscribe #{account.email} to list: #{mailchimp_list_id}/)

        mailchimp_mailing_list.subscribe(account: account)
      end
    end
  end

  describe "#update" do
    context "when Mailchimp is enabled" do
      let(:mailchimp_enabled) { true }

      it "calls the appropriate Mailchimp method with the expected payload to update the account" do
        expect(mailchimp_list).to receive_message_chain(:members, :update)
          .with(
            body: {
              email_address: account.email,
              location: {
                latitude: account.latitude,
                longitude: account.longitude
              },
              merge_fields: {
                BIRTHYEAR: account.date_of_birth.year,
                COUNTRY: account.country,
                FNAME: account.first_name,
                LNAME: account.last_name,
                NAME: account.full_name,
                PARENTNAME: account.student_profile.parent_guardian_name,
                PARENTREG: account.parent_registered?
              }
            }
          )

        mailchimp_mailing_list.update(account: account)
      end

      context "when currently_subscribed_as is provided (needed when the email address has been udpated)" do
        let(:currently_subscribed_as) { "kathy@example.com" }

        it "uses the currently_subscribed_as email address for the subscriber_hash" do
          expect(mailchimp_list).to receive_message_chain(:members, :update)
            .with(
              body: {
                email_address: account.email,
                location: {
                  latitude: account.latitude,
                  longitude: account.longitude
                },
                merge_fields: {
                  BIRTHYEAR: account.date_of_birth.year,
                  COUNTRY: account.country,
                  FNAME: account.first_name,
                  LNAME: account.last_name,
                  NAME: account.full_name,
                  PARENTNAME: account.student_profile.parent_guardian_name,
                  PARENTREG: account.parent_registered?
                }
              }
            )

          mailchimp_mailing_list.update(
            account: account,
            currently_subscribed_as: currently_subscribed_as
          )
        end
      end

      context "when there is a Mailchimp error" do
        let(:error_message) { "Out of gas!" }

        before do
          allow(mailchimp_list).to receive_message_chain(:members, :update)
            .and_raise(Gibbon::MailChimpError, error_message)
        end

        it "logs the error message" do
          expect(logger).to receive(:error).with(/#{error_message}/)

          mailchimp_mailing_list.update(account: account)
        end

        it "creates a notification via the error_notifier" do
          expect(error_notifier).to receive(:notify).with(/#{error_message}/)

          mailchimp_mailing_list.update(account: account)
        end
      end
    end

    context "when Mailchimp is disabled" do
      let(:mailchimp_enabled) { false }

      it "logs a message" do
        expect(logger).to receive(:info)
          .with(/Trying to update #{account.email} on list: #{mailchimp_list_id}/)

        mailchimp_mailing_list.update(account: account)
      end
    end
  end

  describe "#delete" do
    let(:email_address) { "diane@example.com" }

    context "when Mailchimp is enabled" do
      let(:mailchimp_enabled) { true }

      it "calls the appropriate Mailchimp method to delete the account" do
        expect(mailchimp_list).to receive_message_chain(:members, :delete)

        mailchimp_mailing_list.delete(email_address: email_address)
      end

      context "when there is a Mailchimp error" do
        let(:error_message) { "Out of bananas!" }

        before do
          allow(mailchimp_list).to receive_message_chain(:members, :delete)
            .and_raise(Gibbon::MailChimpError, error_message)
        end

        it "logs the error message" do
          expect(logger).to receive(:error).with(/#{error_message}/)

          mailchimp_mailing_list.delete(email_address: email_address)
        end

        it "creates a notification via the error_notifier" do
          expect(error_notifier).to receive(:notify).with(/#{error_message}/)

          mailchimp_mailing_list.delete(email_address: email_address)
        end
      end
    end

    context "when Mailchimp is disabled" do
      let(:mailchimp_enabled) { false }

      it "logs a message" do
        expect(logger).to receive(:info)
          .with(/Trying to delete #{email_address} from list: #{mailchimp_list_id}/)

        mailchimp_mailing_list.delete(email_address: email_address)
      end
    end
  end
end
