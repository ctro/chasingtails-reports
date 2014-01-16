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
#

class Report < ActiveRecord::Base
	belongs_to :client
	has_many :report_dogs, :dependent => :destroy
	has_many :dogs, :through => :report_dogs
	has_many :assets, :dependent => :destroy

	validates_presence_of :client, :walk_date, :walk_time, :weather, :recap,
		:pees, :poops, :energy, :vocalization, :overall, :walk_duration

	before_create :set_uuid

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
end
