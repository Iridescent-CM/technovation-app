class EnablePgSearch < ActiveRecord::Migration[5.1]
  def change
    add_index :accounts,
      :first_name,
      name: "trgm_first_name_indx",
      using: :gist,
      order: {first_name: :gist_trgm_ops}

    add_index :accounts,
      :last_name,
      name: "trgm_last_name_indx",
      using: :gist,
      order: {last_name: :gist_trgm_ops}

    add_index :accounts,
      :email,
      name: "trgm_email_indx",
      using: :gist,
      order: {email: :gist_trgm_ops}
  end
end
