class Notification < ApplicationRecord
  belongs_to :user

  before_create :set_current_date

  def time_difference_in_words
    from_time = date
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

  private

  def set_current_date
    self.date = DateTime.now
  end
end
