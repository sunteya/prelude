module ApplicationHelper

  def return_link(default_url, label = "返回")
    url = params[:ok_url].blank? ? default_url : params[:ok_url]
    link_to label, url, :class => 'btn'
  end
  
  def cancel_link(default_url)
    return_link(default_url, '取消')
  end
  
  def ok_url_tag
    hidden_field_tag "ok_url", params[:ok_url] if params[:ok_url]
  end
  
  def subdomain(prefix)
    subdomains = request.subdomains
    subdomains.unshift(prefix)
    subdomains.join(".")
  end

  def number_to_human_size_with_negative(size, options = {})
    positive_string = number_to_human_size(size.abs, options)
    sign = size < 0 ? '-' : ''
    "#{sign}#{positive_string}".html_safe
  end
  
end
