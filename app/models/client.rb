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
#  deleted_at :datetime
#

class Client < ActiveRecord::Base
	acts_as_paranoid
	
	has_many :dogs, :dependent => :destroy
	has_many :reports, :dependent => :destroy

	validates_presence_of :name, :email
end
