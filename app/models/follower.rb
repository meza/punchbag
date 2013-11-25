class Follower
  include MongoMapper::EmbeddedDocument

  key :username, String
  key :email, String
  key :original_id, String
end
