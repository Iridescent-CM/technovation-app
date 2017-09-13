module MigrateLegacySeasons
  def self.call(model_name, logger = Logger.new("/dev/null"))
    klass = model_name.to_s.camelize.constantize

    klass.reset_column_information

    klass.find_each do |record|
      logger.info(
        "================================================================"
      )

      season_ids = TestSetup::LegacySeasonRegistration
        .where(registerable: record)
        .pluck(:season_id)

      years = TestSetup::LegacySeason
        .where(id: season_ids)
        .pluck(:year)

      logger.info(
        "#{record.class.name}##{record.id} should be in seasons: #{years}"
      )

      record.update_columns(seasons: years)

      logger.info(
        "#{record.class.name}##{record.id} was set to seasons: #{record.seasons}"
      )
    end
  end

  module TestSetup
    def self.call(model)
      unless ActiveRecord::Migration.table_exists?("seasons")
        ActiveRecord::Migration.create_table("seasons") do |t|
          t.integer :year
        end
      end

      unless ActiveRecord::Migration.table_exists?("season_registrations")
        ActiveRecord::Migration.create_table("season_registrations") do |t|
          t.integer :season_id
          t.string :registerable_type
          t.integer :registerable_id
        end
      end

      LegacySeason.create!(year: 2015)
      LegacySeason.create!(year: 2016)
      LegacySeason.create!(year: 2017)

      registerable = FactoryGirl.create(model)

      LegacySeason.all.each do |season|
        LegacySeasonRegistration.create!({
          season: season,
          registerable: registerable,
        })
      end
    end

    class LegacySeason < ActiveRecord::Base
      self.table_name = "seasons"
      has_many :season_registrations, class_name: "LegacySeasonRegistration"
      has_many :registerables, through: :season_registrations
    end

    class LegacySeasonRegistration < ActiveRecord::Base
      self.table_name = "season_registrations"
      belongs_to :season, class_name: "LegacySeason"
      belongs_to :registerable, polymorphic: true
    end
  end
end
