class ReportMailer < ActionMailer::Base
	default to: "info@chasingtailsjh.com"
  default from: "do-not-reply@chasingtailsjh.com"

  def new_report_email(report)
    @report = report
    
    mail(from: @report.user.email, subject: 'New Report Card')
  end
end
