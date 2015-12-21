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
#  picture_id           :string(255)
#

class Asset < ActiveRecord::Base

	belongs_to :report
	attachment :picture, type: :image

  # validates_presence_of_attachment :picture
	# validates_attachment_size :picture, :less_than => 5.megabytes

end
