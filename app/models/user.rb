class User < ApplicationRecord
  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }

  has_many :events, dependent: :destroy
end
