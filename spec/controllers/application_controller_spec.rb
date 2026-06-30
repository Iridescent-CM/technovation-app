require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index
      render plain: needs_filestack?.to_s
    end
  end

  describe "#needs_filestack?" do
    it "is false until Filestack upload UI opts in" do
      get :index

      expect(response.body).to eq("false")
    end

    it "is true after needs_filestack!" do
      controller.needs_filestack!

      get :index

      expect(response.body).to eq("true")
    end
  end
end
