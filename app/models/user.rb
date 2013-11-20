class User
  include MongoMapper::Document
  include ActiveModel::SecurePassword
  before_save { self.email = email.downcase }
  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

  key :username, String
  key :email, String
  key :password_digest, String
  timestamps!
  has_secure_password
end
