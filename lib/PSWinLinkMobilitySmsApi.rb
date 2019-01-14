require "PSWinLinkMobilitySmsApi/version"
require "PSWinLinkMobilitySmsApi/sms"
require "net/http"
require "rubygems"
require "xmlsimple"

module PSWinLinkMobilitySmsApi
  class Error < StandardError; end

  class << self; attr_accessor :config, :url end

  @url = 'https://simple.pswin.com/'

  @config = {:username => "", :password => ""}


end
