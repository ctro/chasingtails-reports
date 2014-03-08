class ReportMailer < ActionMailer::Base
  def new_report_email(report)
    @report = report
    
    opts = {
    	from: "fredthedog@chasingtailsjh.com",
    	to: @report.client.email,
    	cc: ["info@chasingtailsjh.com", @report.user.email],
    	subject: "Report Card: #{@report.dog_names} #{@report.walk_date.strftime("%m.%d.%y")}"
    }

    mail(opts)
  end
end
