# Reports!
class ReportUser < ActiveRecord::Migration
  def change
    add_column :reports, :user_id, :integer
  end
end
