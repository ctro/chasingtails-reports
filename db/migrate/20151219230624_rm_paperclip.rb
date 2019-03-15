# frozen_string_literal: true

# Move away from paperclip
class RmPaperclip < ActiveRecord::Migration
  def change
    # We never enabled paperclip, so no worries.
    # remove_column :assets, :picture_file_name
    # remove_column :assets, :picture_content_type
    # remove_column :assets, :picture_file_size
    # remove_column :assets, :picture_updated_at
  end
end
#  created_at           :datetime
#  updated_at           :datetime
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  picture_id           :string(255)
#
