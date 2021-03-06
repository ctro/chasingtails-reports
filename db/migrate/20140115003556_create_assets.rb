# frozen_string_literal: true

# Assets are pictures
class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer :report_id
      t.timestamps
    end

    # Don't currently use paperclip, so don't worry.
    # add_attachment :assets, :picture
  end

  def self.down
    drop_table :assets
  end
end
