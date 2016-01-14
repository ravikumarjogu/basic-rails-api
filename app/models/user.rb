class User < ActiveRecord::Base
   before_save { email.downcase! }
   after_create :generate_api_access_token
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}

  has_secure_password
  has_one :api_key
  validates :password, presence: true, length: { minimum: 6 }
  private
    def generate_api_access_token
      ApiKey.create(user: self)
    end
end
