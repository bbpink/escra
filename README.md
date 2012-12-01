# escra
web scraper for image files

## features
- crawling the website, and saves all image files
- extensions filter
- filesize filter
- width-height filter
- file rename (option)
- delay time for scraping (option: default time is 1 sec)
- use caches on mongodb (option)

## requirements
- Ruby 1.9.2 up
- bundler (gem)
- libxslt-devel (for nokogiri gem)
- ImageMagick-devel (for rmagick gem)
- mongodb (option for heavy using)

## installing
Install the requiements and do this.
    git clone https://github.com/bbpink/escra.git
    cd escra
    bundle install

## settings
You can modify the config file (/config.yml), like following.
- extensions
Set extensions you want to save.
- delay
Set delay time second order.
- usemongo
If you scrape a lot of websites, install the mongodb and set this true.
- rename
If you want to save the images differently from original name, set this true.
- minsize
minimum filesize of image files to save.
- minwidth
minimum width of image files to save.
- minheight
minimum height of image files to save.
- directories
If you want to arrange paths, change this section.

## usage
    ruby escra.rb [url] [url] ...
You can set the urls and crawling each of them.
And you can find the images at /dat/img/ after execution.

## copyright
&copy;2012- [bbpink](https://twitter.com/bbpink "bbpink").
escra can be copied and changed under [new BSD License](http://opensource.org/licenses/BSD-3-Clause "new BSD License").
