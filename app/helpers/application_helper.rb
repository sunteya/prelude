#encoding: utf-8
module ApplicationHelper

  def return_link(default_url, label = "返回")
    url = params[:ok_url].blank? ? default_url : params[:ok_url]
    link_to label, url, :class => 'btn'
  end
  
  def cancel_link(default_url)
    return_link(default_url, '取消')
  end

end
