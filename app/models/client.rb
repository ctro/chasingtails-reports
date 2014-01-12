class Client < ActiveRecord::Base
	has_many :dogs
	has_many :reports
end
