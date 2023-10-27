class Comment < ApplicationRecord
  include CookieHandler
  
  belongs_to :user
  belongs_to :project

  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy

  def time_difference_in_words
    from_time = created_at
    to_time = Time.now
    distance_in_seconds = (from_time - to_time).to_i.abs
  
    case
    when distance_in_seconds < 1.minute
      "just now"
    when distance_in_seconds < 1.hour
      "#{distance_in_seconds / 1.minute} minutes ago"
    when distance_in_seconds < 1.day
      "#{distance_in_seconds / 1.hour} hours ago"
    else
      "#{distance_in_seconds / 1.day} days ago"
    end
  end
end
