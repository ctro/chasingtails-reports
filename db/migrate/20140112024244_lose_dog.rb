class LoseDog < ActiveRecord::Migration
  def change
  	remove_column :reports, :dog
  end
end
