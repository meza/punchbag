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
  many :followers, :as => :follows
  many :followers
  timestamps!
  has_secure_password

  def follow(user)
    self.push(:follows => Follower.new(:username => user.username, :email => user.email, :original_id=>user.id).to_mongo)
    user.push(:followers => Follower.new(:username => self.username, :email => self.email, :original_id=>self.id).to_mongo)

  end

  def unfollow(user)

    self.follows.delete_if { |follower|
      follower['username'] == user.username
    }
    self.set(:follows=>self.follows.to_mongo);

    user.followers.delete_if { |follower|
      follower['username'] == self.username
    }
    user.set(:followers=>user.followers.to_mongo)

  end

  def is_follower_of(user)

    xx = User.first('follows.username' => user.username)

    return !xx.nil?
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
