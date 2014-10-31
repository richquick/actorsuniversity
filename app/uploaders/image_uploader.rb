class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :web do
    version(:thumb    ){ process :resize_to_fit => [32, 32] }
    version(:preview  ){ process :resize_to_fit => [128, 128] }
    version(:medium   ){ process :resize_to_fit => [256, 256] }
    version(:full     ){ process :resize_to_fit => [512, 384] }
  end
end
