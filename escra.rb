# coding: utf-8
require "rubygems"
require "anemone"
require "open-uri"
require "uri"
require "RMagick"
require "net/http"
require "./lib/util/U"
require "./lib/util/Log"

Net::HTTP.version_1_2

#web scraper for images (https://github.com/bbpink/escra)
class Escra

  def initialize()
    c = "./config.yml"
    @log = Log.new(U.conf(c)["directories"]["log"])
    @temp = U.conf(c)["directories"]["temp"]
    @down = U.conf(c)["directories"]["image"]
    @extensions = U.conf(c)["extensions"] #image extensions
    @delay = U.conf(c)["delay"]
    @minsize = U.conf(c)["minsize"]
    @minwidth = U.conf(c)["minwidth"]
    @minheight = U.conf(c)["minheight"]
    @rename = U.conf(c)["rename"]

    #anemone options
    @options = { :delay => U.conf(c)["delay"] }
    @options[:storage] = Anemone::Storage.MongoDB if U.conf(c)["usemongo"]
  end

  def image?(url)
    !!@extensions.include?(url) 
  end

  #crawling the website
  def crawl(url)
    @log.out("crawling at " + url)

    @visited = []
    Anemone.crawl(url, @options) do |an|
      an.on_every_page do |page|
        current = page.url.to_s

        #has not xml tree (raw files)
        if page.doc.nil? then
          if image?(File.extname(current)) then
            self.get(current, current)
          end
          next #skip
        end

        #extract img tags if exists xml tree
        img = page.doc.xpath("//img")
        u = URI.parse(current)

        #check every img tags
        img.each do |v|

          next if !v.key?("src")
          next if v["src"].length < 4
          next if !image?(File.extname(v["src"]))

          self.get((u + v["src"]).to_s, current)
        end

      end
    end

    self.move
  end

  #download the image file
  def get(url, ref="")

    if @visited.include?(url) then
      return
    else
      @visited.push url
    end

    return if File.exist?(@temp + File.basename(url))

    #http head
    http = Net::HTTP.new(U.getDomain(url))
    res = (ref == "") ? http.head(U.getFilePath(url)) : http.head(U.getFilePath(url), "Referer" => ref)

    #http status code check(200?)
    return if res.code.to_i != 200

    #image file size check
    return if res["content-length"].to_i < @minsize

    #download
    open(@temp + File.basename(url), 'wb') do |file|
      if ref == "" then
        file.puts Net::HTTP.get_response(URI.parse(url)).body
      else
        file.puts http.get(URI.parse(url).path, "Referer" => ref).body
      end
    end

    #width-height check
    im = Magick::ImageList.new(@temp + File.basename(url))
    if !((im.columns >= @minwidth) && (im.rows >= @minheight)) then
      FileUtils.remove_file(@temp + File.basename(url))
      return
    end

    @log.out("saved -> " + File.basename(url))
  end

  #moving images
  def move
    images = Dir::entries(@temp)
    images.each do |v|
      next if (v == "." || v == "..")
      FileUtils.mv(@temp + v, @down + (@rename ? U.uniq62(@down, v) : v))
    end
  end

end

if ARGV.size == 0 then
  puts "url is nothing"
  exit
end

e = Escra.new()

ARGV.each do |url|
  e.crawl(url)
end
