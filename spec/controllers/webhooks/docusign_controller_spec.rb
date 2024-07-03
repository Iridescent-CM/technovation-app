require "rails_helper"

RSpec.describe Webhooks::DocusignController do
  describe "POST #create" do
    before do
      allow(VerifyWebhookPayload).to receive_message_chain(:new, :call, :success?)
        .and_return(valid_webhook_payload)
      allow(WebhookPayload).to receive(:create!)
        .and_return(instance_double(WebhookPayload, id: 1))
      allow(ProcessDocusignWebhookPayloadJob).to receive(:perform_later)
    end

    let(:valid_webhook_payload) { false }

    context "when it's a valid payload" do
      let(:valid_webhook_payload) { true }

      it "saves the payload to the database" do
        expect(WebhookPayload).to receive(:create!)

        post :create
      end

      it "schedules the job to process the payload" do
        expect(ProcessDocusignWebhookPayloadJob).to receive(:perform_later)

        post :create
      end

      it "returns an :ok response status" do
        expect(response).to have_http_status(:ok)

        post :create
      end
    end

    context "when it is not a valid payload" do
      let(:valid_webhook_payload) { false }

      it "does not save the payload to the database" do
        expect(WebhookPayload).not_to receive(:create!)

        post :create
      end

      it "does not schedule the job to process the payload" do
        expect(ProcessDocusignWebhookPayloadJob).not_to receive(:perform_later)

        post :create
      end

      it "returns an :ok response status" do
        expect(response).to have_http_status(:ok)

        post :create
      end
    end
  end
end
