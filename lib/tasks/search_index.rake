desc "Index searchable Mentors"
task index_mentors: :environment do
  if ENV['SWIFTYPE_API_KEY'].blank?
    abort("SWIFTYPE_API_KEY not set")
  end

  if ENV['SWIFTYPE_ENGINE_SLUG'].blank?
    abort("SWIFTYPE_ENGINE_SLUG not set")
  end

  client = Swiftype::Client.new

  MentorAccount.searchable.find_in_batches(batch_size: 100) do |mentors|
    documents = mentors.map do |mentor|
      {:external_id => mentor.id,
       :fields => [{:name => 'title', :value => mentor.full_name, :type => 'string'},
                   {:name => 'created_at', :value => mentor.created_at.iso8601, :type => 'date'}]}
    end

    results = client.create_or_update_documents(ENV['SWIFTYPE_ENGINE_SLUG'], MentorAccount.model_name.name.downcase, documents)

    results.each_with_index do |result, index|
      puts "Could not create #{mentors[index].title} (##{mentors[index].id})" if result == false
    end
  end
end

desc "Index Accounts for Admins"
task index_accounts: :environment do
  if ENV['SWIFTYPE_API_KEY'].blank?
    abort("SWIFTYPE_API_KEY not set")
  end

  if ENV['SWIFTYPE_ENGINE_SLUG'].blank?
    abort("SWIFTYPE_ENGINE_SLUG not set")
  end

  client = Swiftype::Client.new

  Account.find_in_batches(batch_size: 100) do |accounts|
    documents = accounts.map do |account|
      { external_id: account.id,
        fields: [{ name: 'name', value: account.full_name, type: 'string' },
                 { name: 'email', value: account.email, type: 'string' },
                 { name: 'id', value: account.id, type: 'integer' },
                 { name: 'created_at', value: account.created_at.iso8601, type: 'date' }] }
    end

    results = client.create_or_update_documents(ENV['SWIFTYPE_ENGINE_SLUG'], "adminaccounts", documents)

    results.each_with_index do |result, index|
      if result
        puts "Created/updated #{accounts[index].full_name} (##{accounts[index].id})"
      else
        puts "COULD NOT CREATE/UPDATE #{accounts[index].full_name} (##{accounts[index].id})"
      end
    end
  end
end
