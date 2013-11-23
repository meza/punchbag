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
  key :follows, Array
  key :followers, Array
  timestamps!
  has_secure_password

  def follow(user)
    following = self.follows
    following << user.id.to_s
    self.set(:follows=>following)

    followers = user.followers
    followers << self.id.to_s
    user.set(:followers => followers)

  end

  def unfollow(user)
    following = self.follows
    following.delete(user.id.to_s)
    self.set(:follows=>following)

    followers = user.followers
    followers.delete(self.id.to_s)
    user.set(:followers => followers)

  end

  def is_follower_of(user)
    self.follows.include?(user.id.to_s)
  end

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
