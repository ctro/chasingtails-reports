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
  test 'required data' do
    s = clients(:Steph)
    assert s.save

    s.name = ''
    s.email = ''
    refute s.validate
    assert_equal 2, s.errors.count
  end

  test 'strip_address' do
    c = Client.new(address: "Box 666 \r\n Lupine way")
    refute_match "\r", c.strip_address
    refute_match "\n", c.strip_address
  end
end
