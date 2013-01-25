class User
  include Mongoid::Document
  include Mongoid::Search

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :cdrs
  has_many :statistics
  has_many :rents

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :login,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  
  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  ## Role of User
  field :admin, :type => Boolean, :default => false
  ## proxy domain
  field :domain, :type => String, :default => ""

  validates :login, :uniqueness => true

  def find_or_initial_hour_statistic(&block)
    statistic = self.statistics.where(:year => Time.now.year, :month => Time.now.month, :day => Time.now.day, :hour => :Time.now.hour) || self.statistics.new
    yield(statistic) if block
    statistic
  end
  
  def find_the_hour_cdrs
    cdrs = self.cdrs.where(:created_at => Time.now.hour.beginning_of_hour..Time.now.end_of_hour).all
  end
  
  def the_hour_total_size
    cdrs = self.find_last_passed_hours_cdrs
    size = cdrs.map(&:size).inject(&:+)
  end
end
