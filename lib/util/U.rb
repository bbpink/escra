require "yaml"

class U
  def self.get62()
    chars = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
    le = chars.length
    keys = [rand(le), rand(le), rand(le), rand(le), rand(le), rand(le)]
    chars[keys[0]] + chars[keys[1]] + chars[keys[2]] + chars[keys[3]] + chars[keys[4]] + chars[keys[5]]
  end

  def self.uniq62(path, filename)
    files = Dir::entries(path)
    newname = self.get62() + File.extname(filename)
    if files.include?(newname)
      self.uniq62(path, filename)
    else
      newname
    end
  end

  def self.conf(configpath)
    YAML::load_file(configpath)
  end

  def self.now()
    Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def self.getDomain(url)
    t = url.sub("http://", "")
    t.slice(0, t.index("/"))
  end

  def self.getFilePath(url)
    url.sub("http://" + getDomain(url), "")
  end
end
