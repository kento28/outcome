class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile
  has_many :items
  has_many :comments
  has_many :likes
  has_many :relationships

  validates :username, presence: true, uniqueness: { case_sensitive: true}

end
