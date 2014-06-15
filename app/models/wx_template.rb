class WxTemplate < ActiveRecord::Base
  attr_accessible :menu_id, :name, :ret_content, :ret_type, :user_id
  scope :source_type, lambda {|menu_id| where(:menu_id => menu_id)}

  def render vars
    template = '<%="'+ret_content.content+'"%>' 
    ERB.new(template).result(OpenStruct.new(vars).instance_eval{binding})
  end
end
