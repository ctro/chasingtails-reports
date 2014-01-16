# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Chasingtails::Application.initialize!

# Configure all environments
Chasingtails::Application.configure do

	# paperclip/aws
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  }
  
end
