class User < ActiveRecord::Base

  attr_reader :password

  after_initialize :ensure_session_token

  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password cannot be blank" }
  validates :password, length: { minimum: 8, allow_nil: true }

  has_many :moderated_subs,
    primary_key: :id,
    foreign_key: :moderator_id,
    class_name: :Sub

  has_many :posts,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :Post

  def password=(password)
    pw_dig = BCrypt::Password.create(password)
    self.password_digest = pw_dig
  end

  def is_password?(password)
    pw_dig = BCrypt::Password.new(self.password_digest)
    pw_dig.is_password?(password)
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(32)
  end

  def reset_session_token
    self.update(session_token: self.class.generate_session_token)
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user.nil?
      "Error: Username not found"
    elsif user.is_password?(password)
      user
    else
      "Error: Incorrect password"
    end
  end

end
