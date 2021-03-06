# frozen_string_literal: true

# Add full name
class UserName < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
  end

  def self.down
    remove_column :users, :name
  end
end
