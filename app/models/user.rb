class User
  include ActiveGraph::Node
  include ActiveModel::SecurePassword

  has_secure_password

  property :name, type: String
  property :email, type: String
  property :password, type: String
  property :password_digest, type: String
  property :password_confirmation, type: String
end
