class EnablePgSearchOnTeams < ActiveRecord::Migration[5.1]
  def change
    add_index :teams,
      :name,
      name: "trgm_team_name_indx",
      using: :gist,
      order: {name: :gist_trgm_ops}
  end
end
