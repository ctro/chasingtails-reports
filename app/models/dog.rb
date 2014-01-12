class Dog < ActiveRecord::Base
	belongs_to :client
	has_many :report_dogs
	has_many :reports, :through => :report_dogs
end
