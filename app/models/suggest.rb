class Suggest < ApplicationRecord
    belongs_to :clause

    SUGGEST_TYPE = {
      1 => "CLAUSE DETAILS",
      2 => "CLAUSE NAME"
  }

    STATUS = {
     1 =>  "OPEN",
     2 => "PENDING",
     3 => "RESOLVED",
     4 =>  "CLOSED"
    }

    PRIORITY = {
      1 => "LOW",
      2 => "MEDIUM",
      3 => "HIGH",
      4 => "Urgent"
    }

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

      def suggest_status
        STATUS[self.status.to_i]
      end

      def suggest_prority
        PRIORITY[self.priority.to_i]
      end

      def sType
        SUGGEST_TYPE[self.suggest_type.to_i]
      end
end
