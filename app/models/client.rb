# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  address    :text
#  created_at :datetime
#  updated_at :datetime
#

class Client < ActiveRecord::Base
	has_many :dogs
	has_many :reports

	validates_presence_of :name, :email
end
