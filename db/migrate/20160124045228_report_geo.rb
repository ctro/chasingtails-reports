# Add geo for reports
class ReportGeo < ActiveRecord::Migration
  def change
    add_column :reports, :lat, :float
    add_column :reports, :lng, :float
  end
end
