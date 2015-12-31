# == Schema Information
#
# Table name: dogs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  client_id  :integer
#  deleted_at :datetime
#

class Dog < ActiveRecord::Base
	acts_as_paranoid
	
	belongs_to :client
	has_many :report_dogs, :dependent => :destroy
	has_many :reports, :through => :report_dogs

	validates_presence_of :name
end
