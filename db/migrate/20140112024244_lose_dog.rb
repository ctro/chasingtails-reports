# move to many dogs.
class LoseDog < ActiveRecord::Migration
  def up
    remove_column :reports, :dog
  end

  def down
    add_column :reports, :dog, :string
  end
end
