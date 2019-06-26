class User < ApplicationRecord
  has_secure_password validations: true

  validates :name, presence: true, length: { maximum: 50 }
  validates :mail, presence: true, uniqueness: true
  has_many :tasks

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
