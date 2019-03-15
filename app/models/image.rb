# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  report_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  asset_id   :string(255)
#
class Image < ActiveRecord::Base
  belongs_to :report
  attachment :asset, type: :image
end
