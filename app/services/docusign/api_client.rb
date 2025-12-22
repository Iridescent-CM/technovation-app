module Docusign
  class ApiClient
    include ActionView::Helpers::TextHelper

    def initialize(
      api_account_id: ENV.fetch("DOCUSIGN_API_ACCOUNT_ID"),
      base_url: ENV.fetch("DOCUSIGN_API_BASE_URL"),
      authentication_service: Docusign::Authentication.new,
      http_client: Faraday,
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @client = http_client.new(
        url: base_url,
        headers: {
          "Authorization" => "Bearer #{authentication_service.access_token}",
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }
      )
      @api_account_id = api_account_id
      @logger = logger
      @error_notifier = error_notifier
    end

    def send_chapter_affiliation_agreement(legal_contact:)
      send_document_to(
        signer: legal_contact,
        params: params_for_legal_contact(legal_contact)
      )
    end

    def send_chapter_volunteer_agreement(chapter_ambassador_profile:)
      send_document_to(
        signer: chapter_ambassador_profile,
        params: params_for_chapter_ambassador_profile(chapter_ambassador_profile)
      )
    end

    def void_document(document)
      response = client.put(
        "v2.1/accounts/#{api_account_id}/envelopes/#{document.docusign_envelope_id}",
        {
          status: "voided",
          voidedReason: "Voided via TG Platform"
        }.to_json
      )

      response_body = JSON.parse(response.body, symbolize_names: true)

      if response.success? || document.expired?
        document.update(
          active: false,
          voided_at: Time.now
        )

        Result.new(success?: true)
      else
        error = "[DOCUSIGN] Error voiding document - #{response_body[:message]}"

        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false, message: "There was an error trying to void a document, please check the logs for more info.")
      end
    end

    private

    attr_reader :client, :api_account_id, :logger, :error_notifier

    Result = Struct.new(:success?, :message, keyword_init: true)

    def send_document_to(signer:, params:)
      response = client.post(
        "v2.1/accounts/#{api_account_id}/envelopes",
        params
      )

      response_body = JSON.parse(response.body, symbolize_names: true)

      if response.success?
        signer.documents.create(
          full_name: signer.full_name,
          email_address: signer.email_address,
          active: true,
          sent_at: Time.now,
          docusign_envelope_id: response_body[:envelopeId]
        )

        Result.new(success?: true)
      else
        error = "[DOCUSIGN] Error sending document - #{response_body[:message]}"

        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false, message: "There was an error trying to send your document, please check the logs for more info.")
      end
    end

    def params_for_legal_contact(legal_contact)
      chapter = legal_contact.chapter

      {
        templateId: ENV.fetch("DOCUSIGN_CHAPTER_AFFILIATION_AGREEMENT_TEMPLATE_ID"),
        templateRoles: [
          {
            name: legal_contact.full_name,
            email: legal_contact.email_address,
            roleName: "signer",
            tabs: {
              textTabs: [
                {
                  documentId: 1,
                  pageNumber: 1,
                  required: true,
                  font: "Georgia",
                  fontSize: "Size10",
                  italic: true,
                  underline: true,
                  value: chapter.organization_name,
                  width: 100,
                  height: 23,
                  xPosition: 398,
                  yPosition: 175
                },
                {
                  anchorString: "with offices in",
                  anchorXOffset: 67,
                  anchorYOffset: -10,
                  font: "Georgia",
                  fontSize: "Size10",
                  italic: true,
                  underline: true,
                  required: true,
                  tabId: "location",
                  tabLabel: "location",
                  value: truncate(chapter.location, length: 30),
                  width: 165
                },
                {
                  anchorString: "Title:",
                  anchorXOffset: 30,
                  anchorYOffset: -11,
                  font: "Georgia",
                  fontSize: "Size12",
                  required: true,
                  tabId: "title",
                  tabLabel: "title",
                  value: legal_contact.job_title,
                  width: 155
                }
              ],
              signHereTabs: [
                {
                  anchorString: "Signature:",
                  anchorXOffset: 65,
                  anchorYOffset: 10
                }
              ],
              dateSignedTabs: [
                {
                  anchorString: "Date:",
                  anchorXOffset: 30,
                  anchorYOffset: -8,
                  font: "Georgia",
                  fontSize: "Size12"
                }
              ],
              fullNameTabs: [
                {
                  anchorString: "Name:",
                  anchorXOffset: 35,
                  anchorYOffset: -8,
                  font: "Georgia",
                  fontSize: "Size12"
                }
              ]
            }
          }
        ],
        status: "sent"
      }.to_json
    end

    def params_for_chapter_ambassador_profile(chapter_ambassador_profile)
      {
        templateId: ENV.fetch("DOCUSIGN_CHAPTER_VOLUNTEER_AGREEMENT_TEMPLATE_ID"),
        templateRoles: [
          {
            name: chapter_ambassador_profile.full_name,
            email: chapter_ambassador_profile.email_address,
            roleName: "signer",
            tabs: {
              textTabs: [
                {
                  documentId: 1,
                  pageNumber: 1,
                  required: true,
                  font: "Georgia",
                  fontSize: "Size10",
                  italic: true,
                  underline: true,
                  value: chapter_ambassador_profile.full_name,
                  width: 100,
                  height: 23,
                  xPosition: 397,
                  yPosition: 173
                },
                {
                  documentId: 1,
                  pageNumber: 1,
                  font: "Georgia",
                  fontSize: "Size10",
                  italic: true,
                  underline: true,
                  value: chapter_ambassador_profile.chapter.organization_name,
                  width: 12,
                  height: 23,
                  xPosition: 65,
                  yPosition: 200
                }
              ],
              signHereTabs: [
                {
                  anchorString: "Signed:",
                  anchorXOffset: 55,
                  anchorYOffset: -7
                }
              ],
              dateSignedTabs: [
                {
                  anchorString: "Date:",
                  anchorXOffset: 30,
                  anchorYOffset: -10,
                  font: "Georgia",
                  fontSize: "Size12"
                }
              ],
              fullNameTabs: [
                {
                  anchorString: "Name:",
                  anchorXOffset: 35,
                  anchorYOffset: -9,
                  font: "Georgia",
                  fontSize: "Size12"
                }
              ]
            }
          }
        ],
        status: "sent"
      }.to_json
    end
  end
end
