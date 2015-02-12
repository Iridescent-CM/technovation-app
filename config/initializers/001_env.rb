

Rails.application.config.env = HashWithIndifferentAccess.new(TemplatedYaml.load_file(Rails.root + 'config' + 'env.yml'))[Rails.env]
#https://github.com/gimite/google-drive-ruby/issues/126