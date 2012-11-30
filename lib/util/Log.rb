class Log

  def initialize(logpath)
    @filename = logpath + Time.now.strftime("%Y%m%d%H%M%S")  + ".log"
  end

  def out(str)
    f = open(@filename, "a")
    f.print Time.now.strftime("%Y/%m/%d %H:%M:%S  ") + str + "\n"
    f.close
  end

end
