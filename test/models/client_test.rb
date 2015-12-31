# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  address    :text
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
