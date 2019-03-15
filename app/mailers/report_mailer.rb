# Report mailer
class ReportMailer < ActionMailer::Base
  def new_report_email(report)
    @report = report
    formatted_date = @report.walk_date.strftime('%m.%d.%y')
    subject = "Report Card: #{@report.dog_names} #{formatted_date}"

    opts = {
      from: 'fredthedog@chasingtailsjh.com', to: @report.client.email,
      cc: ['ali@chasingtailsjh.com', 'hal@chasingtailsjh.com',
           @report.user.email],
      subject: subject
    }

    mail(opts)
  end
end
