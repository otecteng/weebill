require 'spec_helper'
require 'site_session'

describe SiteWorker do
  
  it "upload image" do
    site = Site.create(name:'beicai',phone:'1')
    service_order = ServiceOrder.create(cname:"teng",cmobile:'2',time_service:Time.now)
    service_order.site = site
    service_order.save
    service_order = ServiceOrder.create(cname:"teng2",cmobile:'3',time_service:Time.now)
    service_order.site = site
    service_order.save
    worker = SiteWorker.create()
    worker.site = site
    p worker.upload_image "x"

  	
  end


end
