class ReportDog < ActiveRecord::Base
	belongs_to :report
	belongs_to :dog
end
