# == Schema Information
#
# Table name: report_dogs
#
#  id         :integer          not null, primary key
#  dog_id     :integer
#  report_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class ReportDog < ActiveRecord::Base
	belongs_to :report
	belongs_to :dog
end
