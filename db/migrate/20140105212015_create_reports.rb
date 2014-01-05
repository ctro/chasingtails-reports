class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.date :date
      t.string :dog
      t.string :time
      t.string :weather
      t.text :recap
      t.string :pees
      t.string :poops
      t.string :energy
      t.string :vocalization
      t.string :overall

      t.timestamps
    end
  end
end
