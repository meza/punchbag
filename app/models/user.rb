class User
  include MongoMapper::Document

  key :username, String
  key :email, String

end
