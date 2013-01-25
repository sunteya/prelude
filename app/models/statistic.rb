class Statistic
  include Mongoid::Document
  include Mongoid::Search

  belongs_to :user

  field :time, type: Time
  field :size, type: Integer

  search_in :time
  # search_in :year, :month, :day
  
  def self.add_statistic
    User.each do |user|
      statistic = user.find_or_initial_hour_statistic do |statistic|
        statistic.user = user
        statistic.size = user.the_hour_total_size
        statistic.time = Time.now
        # statistic.day = Time.now.day
        # statistic.month = Time.now.month
        # statistic.year = Time.now.year
      end
      statistic.save
    end
  end
end