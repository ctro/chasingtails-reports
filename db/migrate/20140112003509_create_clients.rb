# frozen_string_literal: true

# Clients
class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.text :address

      t.timestamps
    end
  end
end
