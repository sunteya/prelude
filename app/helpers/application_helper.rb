#encoding: utf-8
module ApplicationHelper

  def return_link(default_url, label = "返回")
    url = params[:ok_url].blank? ? default_url : params[:ok_url]
    link_to label, url, :class => 'btn'
  end
  
  def cancel_link(default_url)
    return_link(default_url, '取消')
  end
  
  def ok_url_tag
    hidden_field "ok_url", params[:ok_url] if params[:ok_url]
  end
  
  def subdomain(prefix)
    subdomains = request.subdomains
    subdomains.unshift(prefix)
    subdomains.join(".")
  end
  
end
