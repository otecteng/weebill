 # encoding: utf-8
class RegionLoader
  RegionData = Struct.new(:name,:pinyin,:pinyin_abbr,:position,:level,:father,:sub_regions)

  def self.read
    data = File.open("#{Rails.root}/config/regions.yml") { |file| YAML.load(file) }
    objs = []
    data.each do |province_k,r|
      r["cities"].each do |city_k,c|
        c["districts"].each do |district_k,d|
          if d["lng"]==nil || d["lng"]=="" then
            pos = read_pos(city_k,district_k)
            if pos then
              p "#{city_k}-#{district_k}-#{pos}"
              d["lng"]=pos["lng"]
              d["lat"]=pos["lat"]
            else
              objs<<"#{city_k}-#{district_k}" 
            end
          end
        end
      end
    end
    File.open("#{Rails.root}/config/regions2.yml","w+") { |file| file.write(data.to_yaml) }
    p objs.length
  end

  def self.read_pos city,district
    conn = Faraday.new(url:'http://api.map.baidu.com',headers: { accept_encoding: 'none' })
    ret = conn.get "/geocoder?address=#{city}#{district}&output=json&src=your|yourAppName"
    begin
      return JSON.parse(ret.body)["result"]["location"]
    rescue
      return nil
    end
  end
end



