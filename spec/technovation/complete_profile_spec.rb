require "spec_helper"

module CompleteProfile
  @@completion_steps = {}

  def self.percentage(profile)
    methods = completion_methods(profile)
    complete_count = methods.select { |m| profile.public_send(m) }.count
    (complete_count / Float(methods.size)).round(2)
  end

  def self.state(profile, step_name)
    method = completion_method(profile, step_name)
    prereqs = pre_requisites(profile, step_name)

    if prereqs.all? { |m| profile.public_send(m) } && profile.public_send(method)
      "complete"
    elsif prereqs.all? { |m| profile.public_send(m) }
      "ready"
    else
      "future"
    end
  end

  def self.complete?(profile, step_name)
    state(profile, step_name) == "complete"
  end

  def self.register_step(config)
    name = config.fetch(:name)
    type = config.fetch(:type)
    method = config.fetch(:completion_method)
    pre_reqs = config.fetch(:pre_requisites) { [] }

    @@completion_steps[type] ||= {}
    @@completion_steps[type][name] ||= {}
    @@completion_steps[type][name][:completion_method] = method
    @@completion_steps[type][name][:pre_requisites] = Array(pre_reqs)
  end

  private
  def self.completion_methods(profile)
    @@completion_steps[profile.type].values.flat_map { |v| v[:completion_method] }
  end

  def self.completion_method(profile, step_name)
    if step = @@completion_steps[profile.type][step_name]
      step[:completion_method]
    else
      raise StepNotRegistered, step_name
    end
  end

  def self.pre_requisites(profile, step_name)
    if !!@@completion_steps[profile.type][step_name]
      pre_requisite_steps(profile, step_name).collect { |s| completion_method(profile, s) }
    else
      raise StepNotRegistered, step_name
    end
  end

  def self.pre_requisite_steps(profile, step_name)
    @@completion_steps[profile.type][step_name][:pre_requisites]
  end

  class StepNotRegistered < StandardError; end
end

RSpec.describe CompleteProfile do
  let(:user) { double(:user, type: 'User',
                             required_one: false,
                             required_two: false,
                             required_three: false) }

  before do
    CompleteProfile.register_step({
      name: :required_step_one,
      type: 'User',
      completion_method: :required_one,
    })

    CompleteProfile.register_step({
      name: :required_step_two,
      type: 'User',
      completion_method: :required_two,
    })

    CompleteProfile.register_step({
      name: :step_with_prereqs,
      type: 'User',
      completion_method: :required_three,
      pre_requisites: :required_step_two,
    })
  end

  it "returns 0.0 for no steps completed" do
    expect(CompleteProfile.percentage(user)).to eq(0.0)
  end

  it "returns float for some steps completed" do
    allow(user).to receive(:required_two) { true }
    expect(CompleteProfile.percentage(user)).to eq(0.33)
  end

  it "returns complete state" do
    allow(user).to receive(:required_two) { true }
    expect(CompleteProfile.state(user, :required_step_two)).to eq("complete")
  end

  it "returns ready state" do
    expect(CompleteProfile.state(user, :required_step_one)).to eq("ready")
  end

  it "returns a future state for steps with pre-requisites" do
    expect(CompleteProfile.state(user, :step_with_prereqs)).to eq("future")
  end

  it "transitions a future to a ready" do
    allow(user).to receive(:required_two) { true }
    expect(CompleteProfile.state(user, :step_with_prereqs)).to eq("ready")
  end

  it "transitions a future to a complete" do
    allow(user).to receive(:required_two) { true }
    allow(user).to receive(:required_three) { true }
    expect(CompleteProfile.state(user, :step_with_prereqs)).to eq("complete")
  end

  it "queries if a step is complete" do
    allow(user).to receive(:required_two) { true }
    expect(CompleteProfile.complete?(user, :required_step_two)).to be true
  end

  it "is not complete without prereqs complete" do
    allow(user).to receive(:required_three) { true }
    expect(CompleteProfile.complete?(user, :step_with_prereqs)).to be false
  end
end
