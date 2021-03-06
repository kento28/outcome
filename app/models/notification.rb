class Notification < ApplicationRecord
  default_scope -> { order(created_at: :DESC) }
  belongs_to :item, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true


end