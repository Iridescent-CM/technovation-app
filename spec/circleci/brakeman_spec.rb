require "spec_helper"

# spec_helper stubs CRM jobs in a before(:each) hook; those constants are only
# autoloaded when Rails is booted. This file is intentionally Rails-free.
unless defined?(CRM)
  module CRM
    class SetupAccountForCurrentSeasonJob
      def self.perform_later(*)
      end
    end

    class UpsertContactInfoJob
      def self.perform_later(*)
      end
    end

    class UpsertProgramInfoJob
      def self.perform_later(*)
      end
    end
  end
end

RSpec.describe "Circle CI Brakeman config" do
  it "runs Brakeman as a CI step" do
    circle_src = File.read("./circle.yml")

    expect(circle_src).to include("Run Brakeman")
    expect(circle_src).to match(/bundle exec brakeman.*--exit-on-warn.*--exit-on-error/m)
  end
end
