# == Schema Information
#
# Table name: reports
#
#  id            :integer          not null, primary key
#  walk_date     :date
#  walk_time     :string(255)
#  weather       :string(255)
#  recap         :text
#  pees          :string(255)
#  poops         :string(255)
#  energy        :string(255)
#  vocalization  :string(255)
#  overall       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  walk_duration :integer
#  client_id     :integer
#  uuid          :string(255)
#  user_id       :integer
#  deleted_at    :datetime
#  no_show       :boolean          default(FALSE)
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
