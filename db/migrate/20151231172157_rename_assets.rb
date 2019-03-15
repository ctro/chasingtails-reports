# frozen_string_literal: true

# Rename things for a new uploader
class RenameAssets < ActiveRecord::Migration
  def change
    # Rename Assets.picture to Assets.asset
    rename_column :assets, :picture_id, :asset_id
    # Rename Assets.* to Images.*
    rename_table :assets, :images
    # Now we Have Images.asset.
  end
end
