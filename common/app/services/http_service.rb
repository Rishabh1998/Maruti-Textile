require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module HttpService

  # This Http Connection Class defines and describes http post request methods
  # Author:: Raj
  class Connection

    # Initialize HttpService with uri
    #
    # Author:: Raj
    # Date:: 14/03/2016
    # Reviewed By::
    #
    # Params:
    # +url+:: uri to be called/requested
    def initialize(uri, force_ssl = true)
      @uri = URI.parse(uri)
      @https = Net::HTTP.new(@uri.host, @uri.port)
      @https.use_ssl = ( @uri.scheme == "https" )
    end

    # make a http post request with form data
    #
    # Author:: Raj
    # Date:: 14/03/2016
    # Reviewed By::
    #
    # Params:
    # +connection+:: http service connection object
    def post_form(connection, trials = 1)
      # trials are number of times to try for aa successful post request
      tries ||= trials
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(connection)
      response = https.request(request)
      _response = JSON.parse(response.body)
      log_response(uri, _response) if _response.present?
      _response

        # Rescue any exception in post request, log it and notify developers via email.
    rescue Exception => e
      # if there are retries left, then retry the request, otherwise notify developers of exception
      if (tries -= 1) > 0
        retry
      else
        Rails.logger.error "Post request failure for #{connection} due to #{e.message}"
        ExceptionNotifier.notify_exception(e,
                                           :data => {:error => "Post request failure for #{connection}"},
                                           exception_recipients: GlobalConstant::CAROOBI_DEVS)
      end
    end

    # make a http post request with json data
    #
    # Author:: Raj
    # Date:: 31/07/2016
    # Reviewed By::
    #
    # Params:
    # +records+:: array of records to be sent to salesforce
    # +json_headers+:: headers to be sent with json post request
    def post_json(records, json_headers)
      log_request(uri, records.to_json)
      # trials are number of times to try for aa successful post request
      tries ||= 2
      response = https.post(uri, records.to_json, json_headers)
      _response = JSON.parse(response.body)
      log_response(uri, _response) if _response.present?
      _response
    rescue Exception => e
      # if there are retries left, then retry the request, otherwise notify developers of exception
      if (tries -= 1) > 0
        retry
      else
        notify_admins({:exception => e, :records => records, :message => 'Post Request Failed: ', url: uri})
      end
    end

    # make a http get request with json data
    #
    # Author:: Raj
    # Date:: 31/07/2016
    # Reviewed By::
    #
    # Params:
    # +json_headers+:: headers to be sent with json request
    def get_json(json_headers, trials = 3)
      tries ||= trials
      response = https.get(uri, json_headers)
      _response = JSON.parse(response.body)
      log_response(uri, _response) if _response.present?
      _response
    rescue Exception => e
      if (tries -= 1) > 0
        retry
      else
        notify_admins({:exception => e, :message => 'Get request failure', uri: uri})
      end
    end

    # make a http put request with json data
    #
    # Author:: Raj
    # Date:: 31/07/2016
    # Reviewed By::
    #
    # Params:
    # +json_headers+:: headers to be sent with json request
    def put_json(json_headers, params, trials = 1)
      log_request(uri, params.to_json)
      tries ||= trials
      response = https.patch(uri, params.to_json, json_headers)
      log_response(uri, response) if response.present?
      response.body
    rescue Exception => e
      if (tries -= 1) > 0
        retry
      else
        notify_admins({:exception => e, :message => 'Put request failure', uri: uri})
        Rails.logger.info "Put request failure due to #{e.message}"
      end
    end

    # make a http post request with xml data
    #
    # Author:: Raj
    # Date:: 31/07/2016
    # Reviewed By::
    #
    # Params:
    #json_headers+:: headers to be sent with json request

    def post_xml(xml_string)
      log_request(uri, xml_string)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = xml_string
      request.content_type = 'text/xml'
      response = https.request(request)
      log_response(uri, response.body) if response.present?
      response
    rescue Exception => e
      notify_admins({:exception => e, :records => [], :message => 'Post Request Failed: ', url: uri})
    end

    protected
    attr_reader :uri, :https

    private
    def notify_admins(params)
      Rails.logger.error "#{params[:message]} #{params[:exception].message}"
      ExceptionNotifier.notify_exception(params[:exception], data: {
          error: params[:message],
          records: params[:records],
          uri: uri
      }, exception_recipients: GlobalConstant::CAROOBI_DEVS)
    end

    def log_request(uri, data)
      Rails.logger.info "*************** Request for #{uri} ***************"
      Rails.logger.info "#{data.inspect}"
      Rails.logger.info "*************** Request for #{uri} ***************"
    end

    def log_response(uri, data)
      Rails.logger.info "*************** Response for #{uri} ***************"
      Rails.logger.info "#{data.inspect}"
      Rails.logger.info "*************** Response for #{uri} ***************"
    end
  end
end