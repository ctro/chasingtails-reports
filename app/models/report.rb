# == Schema Information
#
# Table name: reports
#
#  id            :integer          not null, primary key
#  walk_date     :date
#  walk_time     :string(255)
#  weather       :string(255)
#  recap         :text
#  pees          :string(255)
#  poops         :string(255)
#  energy        :string(255)
#  vocalization  :string(255)
#  overall       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  walk_duration :integer
#  client_id     :integer
#  uuid          :string(255)
#  user_id       :integer
#

class Report < ActiveRecord::Base
	belongs_to :client
	belongs_to :user
	has_many :report_dogs, :dependent => :destroy
	has_many :dogs, :through => :report_dogs
	has_many :assets, :dependent => :destroy

	validates_presence_of :dogs, :walk_date, :walk_time, :walk_duration,
		:client, :weather, :recap, :pees, :poops, :energy, :vocalization, :overall

	# Validates this format: YYYY-M(M)-D(D)
	#   a little more lax than HTML5.
	DATE_REGEX = /\d{4}-\d{1,2}-\d{1,2}/

	# Validates this format: HH:MM
	#   Military time.  Sorry Android.
	TIME_REGEX = /\d{2}:\d{2}/

  # Validates an integer
	DURATION_REGEX = /\d+/

	validates :walk_date, format: { with: DATE_REGEX,
    message: "Date should look like YYYY-MM-DD" }

  validates :walk_time, format: { with: TIME_REGEX,
  	message: "Time should look like HH:MM -- yeah, military time." }

  validates :walk_duration, format: { with: DURATION_REGEX,
  	message: "Duration should be a number like 60 or 90" }

  validate :presence_of_assets

	before_create :set_uuid
	after_create :deliver_new_report_email

	accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a['picture'].nil? }

	def to_param
		uuid
	end

	def dog_names
		dogs.map(&:name).join(', ')
	end

	private
	def set_uuid
		self.uuid = SecureRandom.uuid
	end

	def deliver_new_report_email
    ReportMailer.new_report_email(self).deliver
  end

  def presence_of_assets
  	# Custom message
  	self.errors[:base] << "Pictures can't be blank" if assets.blank?
  end

end
