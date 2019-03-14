class ReportsUuid < ActiveRecord::Migration
  def change
    add_column :reports, :uuid, :string
  end
end
