CarrierWave.configure do |config|
  config.enable_processing = !Rails.env.test?

  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.root = "#{Rails.root}/public"
  else
    config.fog_credentials = {
      # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
      # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_ASSET_URL=http://assets.example.com/ S3_BUCKET_NAME=s3_bucket/folder
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :region                => ENV['AWS_REGION']
    }


    config.storage = :fog
    config.fog_directory  = ENV['AWS_BUCKET']                     # required
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end


end
