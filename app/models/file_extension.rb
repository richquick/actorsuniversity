module FileExtension
  def type_from_extension extension
    {
      image: image_extensions,
      audio: audio_extensions,
      video: video_extensions,
      office_word: office_word_extensions,
      office_excel: office_excel_extensions,
      office_powerpoint: office_powerpoint_extensions,
      document: generic_document_extensions,
      pdf: %w(pdf)
    }.each do |type, list|
      return type if list.include?(extension) 
    end

    nil
  end

  def extension_white_list
    %w(pdf) + 
      generic_document_extensions +
      image_extensions +
      audio_extensions +
      video_extensions +
      office_word_extensions +
      office_excel_extensions +
      office_powerpoint_extensions
  end

  def generic_document_extensions
    %w(csv txt rtf sldx sldm thmx)
  end

  def image_extensions
    %w(jpeg jpg gif png bmp tif tiff)
  end

  def audio_extensions
    %w(mp3 wav)
  end

  def video_extensions
    %w(mp4 mpeg mpg mov wmv m4v swf)
  end

  def office_word_extensions
    %w(doc dot docx docm dotx dotm)
  end

  def office_excel_extensions
    %w(xls xlt xlsx xlsm xltx xltm xlsb xlam)
  end

  def office_powerpoint_extensions
    %w(pptx pptm potx potm ppam ppsx ppsm ppt pps)
  end

  extend self
end
