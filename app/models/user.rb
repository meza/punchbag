class User
  include MongoMapper::Document
  include ActiveModel::SecurePassword
  before_save { self.username = username.downcase }
  before_create :create_remember_token

  validates :username, presence: true, :uniqueness => true
  validates :password, presence: true

  key :username, String
  key :password_digest, String
  key :remember_token, String
  many :followers, :as => :follows
  many :followers
  timestamps!
  has_secure_password

  def follow(user)

    unless user.is_follower_of(self)
      self.push(:follows => Follower.new(:username => user.username, :original_id => user.id).to_mongo)
      user.push(:followers => Follower.new(:username => self.username, :original_id => self.id).to_mongo)
    end
  end

  def unfollow(user)

    unless self.follows.nil?
      self.follows.delete_if { |follower|
        follower['username'] == user.username
      }
      self.set(:follows => self.follows.to_mongo);
    end

    unless user.followers.nil?
      user.followers.delete_if { |follower|
        follower['username'] == self.username
      }
      user.set(:followers => user.followers.to_mongo)
    end

  end

  def is_follower_of(user)
    if user.followers.nil?
      return false
    end
    user.followers.each do |f|
      if f['username'] == self.username
        return true
      end
    end

    return false
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
