# == Schema Information
#
# Table name: reports
#
#  id            :integer          not null, primary key
#  walk_date     :date
#  dog           :string(255)
#  time          :string(255)
#  weather       :string(255)
#  recap         :text
#  pees          :string(255)
#  poops         :string(255)
#  energy        :string(255)
#  vocalization  :string(255)
#  overall       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  walk_time     :time
#  walk_duration :integer
#

class Report < ActiveRecord::Base
	belongs_to :client
	has_many :report_dogs
	has_many :dogs, :through => :report_dogs

	def dog_names
		dogs.map(&:name).join(', ')
	end
end
