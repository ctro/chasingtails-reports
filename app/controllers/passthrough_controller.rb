class PassthroughController < ApplicationController
	def index
		redirect_to current_user.admin? ? reports_path : new_report_path
	end
end