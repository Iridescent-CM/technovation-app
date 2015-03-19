hash = TemplatedYaml.load_file(Rails.root + 'config' + 'env.yml')
hash = HashWithIndifferentAccess.new(hash)
Rails.application.config.env = hash[:globals].merge(hash[Rails.env]).freeze