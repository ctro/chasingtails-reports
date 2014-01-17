class ReportUser < ActiveRecord::Migration
  def change
  	add_column :reports, :user_id, :integer
  	Report.update_all(:user_id => User.first.id)
  end
end
