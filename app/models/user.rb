class User
  include MongoMapper::Document
  include ActiveModel::SecurePassword
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

  key :username, String
  key :email, String
  key :password_digest, String
  key :remember_token, String
  timestamps!
  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
