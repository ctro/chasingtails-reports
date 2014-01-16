# == Schema Information
#
# Table name: assets
#
#  id                   :integer          not null, primary key
#  report_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

class Asset < ActiveRecord::Base

	belongs_to :report
	
	#validates_attachment_presence :picture
	#validates_attachment_size :picture, :less_than => 5.megabytes

	# paperclip
	has_attached_file :picture, :whiny => false, 
		styles: {
    	thumb: '100x100>',
    	square: '200x200#',
    	medium: '300x300>'
  	}

end
