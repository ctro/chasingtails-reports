# frozen_string_literal: true

# Always Auto-Orient
Refile::MiniMagick.prepend(Module.new do
  %i[limit fit fill pad].each do |action|
    define_method(action) do |img, *args|
      super(img, *args)
      img.auto_orient
    end
  end
end)

# S3 Setup
require 'refile/s3'

aws = {
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: 'us-west-2',
  bucket: ENV['S3_BUCKET'],
  max_size: 12.megabytes # This is max size for all attachments on one form. I think.  This seems huge but it works.
}
Refile.cache = Refile::S3.new(prefix: 'cache', **aws)
Refile.store = Refile::S3.new(prefix: 'store', **aws)
