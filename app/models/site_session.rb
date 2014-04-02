#encoding: UTF-8
class SiteSession < ActiveRecord::Base
  attr_accessible :site_worker_id,:status,:pix,:uid
  belongs_to :site_worker
  state_machine :state, :initial => :pending do
    #after_failure :on => :ignite, :do => :log_start_failure

    event :text  do
      transition :pix_uploaded=>:complished
    end

    event :image  do
      transition :pending=>:pix_uploaded
    end
    
    around_transition do |site_session, transition, block|
      site_session.log_reset
      block.call
    end

    before_transition :pending => :pix_uploaded do |site_session,transition|
    	param = transition.args[0]
    	client = WeechatClient.get_instance "siteworker"
     #    client.download_media param[:MediaId]
        site_session.update_attributes(:pix => param[:MediaId])
    end

    before_transition :pix_uploaded => :complished do |site_session,transition|
    	param = transition.args[0]
    	service_order = ServiceOrder.find_by_id(param[:Content].to_i)
        if !service_order then
            site_session.log "安装单编号错误： #{param[:Content]}, 请检查后重新输入"
           throw :halt
        else
            worker = site_session.site_worker
            service_order.update_attributes(:site_worker_id=>worker.id, :site_pix=>site_session.pix,:status=>"SUBMITTED")
            site_session.update_attributes(:uid => param[:Content],:status =>"OFF")
            site_session.log "session  done!bill: #{site_session.pix}-#{service_order.id}."
        end
    end

    state :pending do
        def message
            "请上传施工图片"  
        end
    end
    state :pix_uploaded do
        def message
            @message + "请输入安装单编号"  
        end
    end
    state :complished do
        def message
            @message + "安装报告已提交，服务人员将尽快完成审核，谢谢！" 
        end
    end
  end

  def log_reset
    @message = ""
  end

  def log message
    @message += message
  end


end
