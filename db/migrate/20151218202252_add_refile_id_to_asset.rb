class AddRefileIdToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :picture_id, :string
  end
end
