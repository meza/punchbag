class Message
  include MongoMapper::Document

  validates :from, presence: true
  validates :to, presence: true
  validates :message, presence: true

  key :from, Follower
  key :to, Follower
  key :message, String
  key :read, Boolean, :default => false

end
