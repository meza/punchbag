class Message
  include MongoMapper::Document

  validates :from, presence: true
  validates :to, presence: true
  validates :message, presence: true

  key :from, User
  key :to, User
  key :message, String

end
