require "./app/technovation/completion_steps"

module ProfileCompletion
  def self.configure(&block)
    config = Configuration.new

    yield(config)

    steps_config = YAML.load(ERB.new(File.read(config.path)).result)
    register_steps(steps_config)
  end

  @@steps = {}

  def self.register_step(account_type, id, config = {})
    links = config.fetch("links") { [] }.map do |link_name, link_config|
      ProfileCompletion::Link.new(
        id,
        link_name,
        link_config.fetch("url") { nil },
        link_config.fetch("link_options") { {} },
        link_config.fetch("tag_options") { {} }
      )
    end

    @@steps[account_type] << ProfileCompletion::Step.new(
                               id,
                               config.fetch("prerequisites") { [] },
                               config.fetch("complete_condition"),
                               links
                             )
  end

  def self.register_steps(config)
    config.each do |account_type, account_type_config|
      @@steps[account_type] = []

      account_type_config.each do |id, step_config|
        register_step(account_type, id, step_config)
      end
    end
  end

  def self.step(id)
    @@steps.values.flatten.find { |step| step.id == id }
  end

  def self.registered_steps(account)
    @@steps.fetch(account.type_name) { [] }
  end

  class Configuration
    attr_accessor :path
  end
end
