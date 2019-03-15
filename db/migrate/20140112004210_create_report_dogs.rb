# frozen_string_literal: true

# Many dogs
class CreateReportDogs < ActiveRecord::Migration
  def change
    create_table :report_dogs do |t|
      t.integer :dog_id
      t.integer :report_id

      t.timestamps
    end
  end
end
