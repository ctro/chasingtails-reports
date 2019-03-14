# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean
#  name                   :string(255)
#  deleted_at             :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @b = users(:Brad)
  end

  test 'require data' do
    assert @b.save

    @b.name = ''
    @b.email = ''
    @b.password = ''
    refute @b.validate
    assert_equal 3, @b.errors.count
  end

  test 'password requirements' do
    @b.password = 'secret'
    refute @b.validate
    assert_match /8 characters/, @b.errors.messages.to_s
  end
end
