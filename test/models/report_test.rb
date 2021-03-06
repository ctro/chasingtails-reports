# frozen_string_literal: true

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
  def setup
    @sr = reports(:Stella)

    # Fixture relationships should make this unnecessary but :shrug:
    @sr.dogs = [dogs(:Stella)]
  end

  test 'unconditional required data' do
    assert @sr.save

    @sr.client = nil
    @sr.dogs = []
    @sr.walk_date = ''
    @sr.walk_time = ''
    @sr.walk_duration = ''
    assert_not @sr.validate

    %w[client dogs walk_date walk_time walk_duration].each do |attribute|
      assert @sr.errors.key?(attribute.to_sym)
    end

    # This does not change with :no_show:
    @sr.no_show = true
    assert_not @sr.save
  end

  test 'conditional required data' do
    assert @sr.save

    @sr.weather = ''
    @sr.recap = ''
    @sr.pees = ''
    @sr.poops = ''
    @sr.energy = ''
    @sr.vocalization = ''
    @sr.overall = ''
    assert_not @sr.validate
    assert_equal 7, @sr.errors.count

    # This changes with :no_show:
    @sr.no_show = true
    assert @sr.validate
  end

  test 'images are not required when no_show is true' do
    assert_equal false, @sr.no_show
    assert @sr.validate
    @sr.images = []
    assert_not @sr.validate
    @sr.no_show = true
    assert @sr.validate
  end

  test 'expected fixture relationships' do
    assert_equal @sr.client, clients(:Steph)
    assert_equal @sr.user, users(:Hal)
    assert_equal @sr.dogs, [dogs(:Stella)]
    assert_equal @sr.images, [images(:Stella)]
  end

  # A similar test for walk_duration doesn't work b/c it's an integer
  # A similar test for walk_date doesn't work b/c it's a date
  test 'time format validations' do
    @sr.walk_time = '$04:20!'
    assert_equal false, @sr.validate
  end

  test 'formatted things' do
    assert_equal @sr.dog_names, 'Stella'

    @slgr = reports(:StellaLanieGrace)
    # Fixture relationships seem broken :shrug:
    @slgr.dogs = [dogs(:Stella), dogs(:Lanie), dogs(:Grace)]
    assert_match(/Stella/, reports(:StellaLanieGrace).dog_names)
    assert_match(/Lanie/, reports(:StellaLanieGrace).dog_names)
    assert_match(/Grace/, reports(:StellaLanieGrace).dog_names)

    assert_equal '09:00 am', reports(:Stella).formatted_walk_time
  end
end
