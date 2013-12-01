class Follower
  include MongoMapper::EmbeddedDocument

  key :username, String
  key :original_id, String
end
