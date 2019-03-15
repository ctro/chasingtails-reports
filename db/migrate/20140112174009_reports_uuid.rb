# frozen_string_literal: true

# Add uuid for report links
class ReportsUuid < ActiveRecord::Migration
  def change
    add_column :reports, :uuid, :string
  end
end
