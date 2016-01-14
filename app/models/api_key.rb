class ApiKey < ActiveRecord::Base
  belongs_to :user
  before_create :generate_token

  private
    def generate_token
      begin 
        self.access_token=SecureRandom.hex.to_s
      end while ApiKey.exists?(access_token: self.access_token)
      begin
        self.access_secret=SecureRandom.hex.to_s
      end while ApiKey.exists?(access_secret: self.access_secret)
    end
end
