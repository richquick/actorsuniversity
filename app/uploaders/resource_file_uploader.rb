class ResourceFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    FileExtension.extension_white_list
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version(:thumb   , if: :image? ){ process :resize_to_fit => [32, 32]    }
  version(:preview , if: :image? ){ process :resize_to_fit => [128, 128]  }
  version(:full    , if: :image? ){ process :resize_to_fit => [512, 384]  }

  def image?(file)
    if model.persisted?
      #TECHDEBT - work out why content type is 
      #getting removed after saving
      return FileExtension.image_extensions.include? model.extension
    end

    if file #TECHBEDT - remove nil guard
      file.content_type =~ /^image/
    end
  end
end
