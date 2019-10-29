# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :login_id, presence: true
  validates :password_digest, presence: true
end
