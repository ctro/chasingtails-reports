require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  test 'new report email' do
    # skip("wip")

    @report = reports(:ReportWithID)
    e = ReportMailer.new_report_email(@report)
    e.deliver_now

    refute ActionMailer::Base.deliveries.empty?

    assert_equal ['fredthedog@chasingtailsjh.com'], e.from
    assert_equal ['idclient@gmail.com'], e.to
    assert_match(/Report Card/, e.subject)
    assert_match(/Howdy/, e.body.to_s)
    # assert_equal read_fixture('invite').join, e.body.to_s
  end

  test 'report email happens even with no-show' do
    assert ActionMailer::Base.deliveries.empty?
    Report.create(
      no_show: true, user: users(:Hal), client: clients(:Steph),
      dogs: [dogs(:PJ)], walk_date: Date.today, walk_time: '13:00',
      walk_duration: '90'
    )
    refute ActionMailer::Base.deliveries.empty?
  end
end
