# frozen_string_literal: true

# Add the first user to log in with
# Should change this user once you log in
class AddFirstUser < ActiveRecord::Migration
  def change
    pw = 'fredrickdouglass'
    User.create(admin: true, name: 'Fredrick Douglass III',
                email: 'info@chasingtailsjh.com', password: pw,
                password_confirmation: pw)
  end
end
