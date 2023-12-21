require "rails_helper"

RSpec.describe "Tasks: submissions namespace" do
  let(:output) { StringIO.new }

  before(:each) do
    $stdout = output
  end

  after(:each) do
    $stdout = STDOUT
  end

  context "rails submissions:submitted_but_incomplete" do
    let(:task) { Rake::Task["submissions:submitted_but_incomplete"] }
    after(:each) { task.reenable }

    let!(:complete) { FactoryBot.create(:submission, :complete) }
    let!(:incomplete) { FactoryBot.create(:submission, :half_complete) }
    let!(:incomplete_but_submitted) {
      sub = FactoryBot.create(:submission, :half_complete)
      sub.publish!
      sub
    }
    let!(:past) {
      sub = FactoryBot.create(:submission, :half_complete)
      sub.publish!
      sub.update(seasons: [Season.current.year - 1])
      sub
    }

    it "lists current submitted (aka published) but incomplete app" do
      task.invoke

      expect(output.string).to include("#{incomplete_but_submitted.id}: #{incomplete_but_submitted.friendly_id}")
      expect(output.string).not_to include("#{complete.id}: #{complete.friendly_id}")
      expect(output.string).not_to include("#{incomplete.id}: #{incomplete.friendly_id}")
    end

    it "doesn't list past season apps" do
      task.invoke

      expect(output.string).not_to include("#{past.id}: #{past.friendly_id}")
    end
  end

  context "rails submissions:unsubmit!" do
    let(:task) { Rake::Task["submissions:unsubmit!"] }
    after(:each) { task.reenable }

    context "targetting current submissions" do
      let(:targeted) { FactoryBot.create_list(:submission, 3, :complete) }
      let(:ignored) { FactoryBot.create(:submission, :complete) }

      it "unsubmits specified apps" do
        expect(ignored).to be_published
        targeted.each do |sub|
          expect(sub).to be_published
        end

        task.invoke(*targeted.map(&:id))

        expect(ignored.reload).to be_published
        targeted.each do |sub|
          expect(sub.reload).not_to be_published
        end
      end
    end

    context "targetting a past submission" do
      let(:targeted) {
        sub = FactoryBot.create(:submission, :complete)
        sub.update(seasons: [Season.current.year - 1])
        sub
      }

      it "doesn't unsubmit anything" do
        task.invoke(targeted.id)

        expect(targeted).to be_published
      end
    end
  end
end
