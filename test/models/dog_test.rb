# == Schema Information
#
# Table name: dogs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  client_id  :integer
#  deleted_at :datetime
#

require 'test_helper'

class DogTest < ActiveSupport::TestCase
  test 'required data' do
    s = dogs(:Stella)
    assert s.save

    s.name = ''
    refute s.validate
  end
end
