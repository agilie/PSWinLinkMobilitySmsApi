require "PSWinLinkMobilitySmsApi/version"

module PSWinLinkMobilitySmsApi

  class Sms
    attr_accessor :to, :message, :msgid, :from

    attr_reader :status, :response_hash

    def initialize(params = {})
      @to = params[:to]
      @message = params[:message]
      @msgid = params[:msgid]
      @from = params[:from]
      @response = nil
      @response_hash = {}
      @status = nil
      @delivered = false
    end

    def deliver
      if valid?
        handle_response(Net::HTTP.post_form(URI.parse(PSWinLinkMobilitySmsApi.url), params_hash))
      end
      delivered?
    end

    def delivered?
      @delivered
    end

    def valid?
      raise(ArgumentError, ":to is required") if @to.nil? or @to.empty?
      raise(ArgumentError, ":message is required") if @message.nil? or @message.empty?
      raise(ArgumentError, ":msgid is required") if @msgid.nil? or @msgid.empty?
      not (@to.nil? or @to.empty? or @message.nil? or @message.empty? or @msgid.nil? or @msgid.empty?)
    end

    private

    attr_accessor :response

    def params_hash
      {
          :USER => PSWinLinkMobilitySmsApi.config[:username],
          :PW => PSWinLinkMobilitySmsApi.config[:password],
          :RCV => @to || "",
          :TXT => @message || "",
          :msgid => @msgid || "",
          :SND => @from || ""
      }
    end

    def handle_response(response)
      @response = response
      @response_hash = {}
      unless @response.nil?
        data = @response.body.split
        @response_hash['error_code'] = data[0]
        @response_hash['status'] = data[1]
        @response_hash['content'] = @response.body

        @status = @response_hash['status']
        @delivered = @status == 'OK'
      end
    end
  end

end
