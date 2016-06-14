module GenerateToken
  def self.call(record, attribute)
    begin
      record.send("#{attribute}=", token_generator.urlsafe_base64)
    end while record[attribute].blank? ||
                record.class.exists?(attribute => record[attribute])
  end

  def self.token_generator
    SecureRandom
  end
end
