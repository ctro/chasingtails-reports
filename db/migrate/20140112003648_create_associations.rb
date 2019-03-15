# Dog relationships
class CreateAssociations < ActiveRecord::Migration
  def change
    add_column :reports, :client_id, :integer
    add_column :dogs, :client_id, :integer
  end
end
