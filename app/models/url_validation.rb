module UrlValidation
  def valid_url_or_resource_file
    return if file? || valid_url?

    errors[:external_resource_url] << "is not a valid URL"
  end

  def valid_url?
    (technically_valid_url? && url_looks_correct?)
  end

  def url_looks_correct?
    url_has_a_dot_in? && url_has_no_spaces?
  end

  #although http://look-mum-no-subdomain is a valid URL it probably isn't for
  #our purposes
  def url_has_a_dot_in?
    (external_resource_url =~ /\./ )
  end

  def url_has_no_spaces?
    (external_resource_url !~ /\s/)
  end

  def technically_valid_url?
    (external_resource_url =~ URI::regexp) || 
      ("http://#{external_resource_url}" =~ URI::regexp)
  end
end
