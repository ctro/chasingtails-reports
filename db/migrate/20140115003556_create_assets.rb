class CreateAssets < ActiveRecord::Migration
	def self.up
		create_table :assets do |t|
			t.integer :report_id
      t.timestamps
    end

    add_attachment :assets, :picture
  end

  def self.down
    drop_table :assets
  end
end
