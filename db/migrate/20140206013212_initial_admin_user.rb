class InitialAdminUser < ActiveRecord::Migration
  def change
  	pw = "fredrickdouglass"
  	User.create(:admin => true, :name => "Fredrick Douglass III", :email => "info@chasingtailsjh.com", :password => pw, :password_confirmation => pw)
  end
end
