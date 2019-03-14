# Itroduce paranoia -- don't ever really delete anything.
class ParanoiaMigration < ActiveRecord::Migration
  def change
    add_column :clients, :deleted_at, :datetime
    add_index  :clients, :deleted_at

    add_column :dogs, :deleted_at, :datetime
    add_index  :dogs, :deleted_at

    add_column :report_dogs, :deleted_at, :datetime
    add_index  :report_dogs, :deleted_at

    add_column :reports, :deleted_at, :datetime
    add_index  :reports, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index  :users, :deleted_at
  end
end
