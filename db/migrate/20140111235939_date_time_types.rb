# frozen_string_literal: true

# Don't use reserved names
class DateTimeTypes < ActiveRecord::Migration
  def change
    rename_column :reports, :date, :walk_date
    rename_column :reports, :time, :walk_time
    add_column :reports, :walk_duration, :integer
  end
end
