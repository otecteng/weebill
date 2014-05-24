 # encoding: utf-8
class Region 
  RegionData = Struct.new(:name,:pinyin,:pinyin_abbr,:position,:level,:father,:sub_regions) do
    def distance_to dst
      p self.name
      
      d1 = (self.position[:lat] - dst.position[:lat]).abs
      d2 = (self.position[:lng] - dst.position[:lng]).abs
      ret = Math.sqrt(d1*d1 + d2*d2)
      p ret 
      ret
    end
  end

  def self.get_region(name,father=nil)
    p "name=#{name}"
    p "father=#{father.name}" if father
    unless @regions
      @regions = []    
      data = File.open("#{Rails.root}/config/regions.yml") { |file| YAML.load(file) }
      data.each do |province_k,r|
        cities = []
        province = RegionData.new(province_k,r["pinyin"],r["pinyin_abbr"],[],1,nil,cities)
        province.father = self
        @regions << province
        r["cities"].each do |k,c|
          districts = []
          cities <<  city = RegionData.new(k,c["pinyin"],c["pinyin_abbr"],[],2,province,districts)
          @regions << city
          
          c["districts"].each do |k,d|
            districts << RegionData.new(k,d["pinyin"],d["pinyin_abbr"],{:lat=>d["lat"],:lng=>d["lng"]},3,city)
            @regions << districts.last
          end

        end
      end      
    end
    ret = @regions.select{|r| r.name =~ /#{name}/}
    if ret.length > 1 && father then
      ret = ret.select{|r| r.father && r.father.name =~/#{father.name}/}.first
    else
      ret = ret.first
    end
    ret
  end

  def self.all
    @regions
  end

  def read_pos
  end  

  def self.confirm(province,city,district)
  end

  # def self.find_near(county,counties)
    
  #   county
  #   return nil unless confirm_city(city)
  #   xx = matrix.select{|x| x[:start]==city}.sort{|x,y| x[:distance]<=>y[:distance]}
  #   xx[1]
  # end

  def summary
  	"#{name},地址:#{address},电话:#{phone},联系人:#{contactor}"
  end
end



