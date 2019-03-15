# frozen_string_literal: true

# Add no-show option
class NoShow < ActiveRecord::Migration
  def change
    add_column :reports, :no_show, :boolean, default: false
  end
end
