task fix_seasons: :environment do
  def logger
    Logger.new($stdout)
  end

  def set_seasons(record)
    logger.info "Removing 2019 from #{record.name}"

    seasons = record.seasons - [2019, 2018]
    seasons << 2018
    record.update(seasons: seasons)
  end

  TeamSubmission.by_season(2019).find_each do |sub|
    set_seasons(sub)
  end

  Account.by_season(2019).find_each do |a|
    set_seasons(a)
  end

  Team.by_season(2019).find_each do |t|
    if Team.by_season(2018).find_by(name: t.name)
      logger.info "DESTROYING 2019 TEAM: #{t.name}"
      t.destroy
    else
      set_seasons(t)
    end
  end

  ParentalConsent.by_season(2019).find_each do |pc|
    set_seasons(pc)
  end
end
