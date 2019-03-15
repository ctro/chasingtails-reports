# frozen_string_literal: true

# == Schema Information
#
# Table name: report_dogs
#
#  id         :integer          not null, primary key
#  dog_id     :integer
#  report_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#
class ReportDog < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :report
  belongs_to :dog
end
