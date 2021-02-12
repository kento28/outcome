class User < ApplicationRecord

  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :commented_items, through: :comments, source: :item
  has_many :likes, dependent: :destroy
  has_many :liked_items, through: :likes, source: :item
  has_many :relationships, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: true }, length: { maximum: 14 }
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  USERNAME_REGEX = /\A[a-zA-Z0-9]+\z/
  validates_format_of :username, with: USERNAME_REGEX, message: 'は半角英数で入力してください'
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'は半角英数のみで両方含めてください'

  def already_liked?(item)
    likes.exists?(item_id: item.id)
  end

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

end
