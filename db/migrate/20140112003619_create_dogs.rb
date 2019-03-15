# frozen_string_literal: true

# Dogs table
class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :name

      t.timestamps
    end
  end
end
