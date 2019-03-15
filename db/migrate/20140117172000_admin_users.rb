# frozen_string_literal: true

# Allow Admins
class AdminUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
  end
end
