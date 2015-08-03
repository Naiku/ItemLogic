require 'openssl'
require 'json'
require 'httparty'

require 'itemlogic/client'

class Itemlogic
  attr_accessor :api_client

  API_PATH = '/v1'

  INTERACTION_TYPES = {
    "SRSP" => "Selected Response (Multiple Choice)",
    "MTRX" => "Selected Response (Matrix)",
    "TEXT" => "Extended Text",
    "ORDR" => "Order",
    "GRID" => "Grid",
    "ASOC" => "Associate",
    "MTCH" => "Matching",
    "GMTC" => "Text Gap Match",
    "SLDR" => "Slider",
    "HTXT" => "HotText",
    "ITXT" => "Inline Text",
    "GFXH" => "Graphic Hotspot",
    "GFXA" => "Graphic Associate",
    "GFXM" => "Graphic Gap Match",
    "GFXX" => "Graphic Coordinate",
    "GFXP" => "Graphic Position",
    "GFXO" => "Graphic Order",
    "GFCT" => "Graph: Cartesian",
    "GFBR" => "Graph: Bar",
    "GFLN" => "Graph: Line",
    "GFLP" => "Graph: Line Plot",
    "GFNL" => "Number Line (Plot)",
    "GFNP" => "Number Line (Place)",
    "GFGP" => "Graph Paper",
    "GFPO" => "Partition Object",
    "DRAW" => "Drawing"
  }

  def initialize(api_credentials)
    self.api_client = Class.new(Itemlogic::Client) do |klass|
      uri = api_credentials['base_uri'] || Itemlogic::Client::BASE_URI
      klass.base_uri(uri)
    end.new(api_credentials)
  end

  class << self
    [:get, :post, :put, :delete].each do |command|
      define_method(command.to_s) do |method, api, path = nil|
        if path.nil?
          path, api = api, nil
        end
        define_method(method) do |options = {}|
          return self.api_client.class.send(command, prepare_path(path.dup, api, options), self.api_client.options.merge(options))
        end
      end
    end
  end

  def prepare_path(path, api, options)
    options = options.dup
    options.each_pair do |key, value|
      regexp_path_option = /(:#{key}$|:#{key}([:\/-_]))/
      if path.match(regexp_path_option)
        if value.blank?
          raise "Blank value for parameter '%s' in '%s'" % [key, path]
        end
        path.gsub!(regexp_path_option, "#{value}\\2")
        options.delete(key)
      end
    end
    if parameter = path.match(/:(\w*)/)
      raise "Missing parameter '%s' in '%s'. Parameters: %s" % [parameter[1], path, options]
    end
    if api
      path = (API_PATHS[api] + path).gsub('//', '/')
    end
    path
  end

  # retreive max_page_size from metadata. Defaults to 100
  def get_page_size(resource)
    @metadata ||= self.metadata()
    @metadata['%s_max_page_size' % resource.split('/').last.singularize] rescue 100
  end

  # Process every object for a resource.
  def all(resource, options = {}, &block)
    _options = options.dup
    _options[:query] ||= {}

    page = 0
    results = []
    begin
      _options[:query][:page] = page + 1
      response = self.send(resource, _options)
      result = response.parsed_response || {}
      page_count = result['page_count']
      page = result['page']
      results.concat(result['results'])
    end while results.any? && page < page_count
    return results
  end


  # See http://help.itemlogic.com
  get :me, '/me'
  get :clients, '/clients'
  get :client, '/client/:client_id/view'
  get :client_banks, '/client/:client_id/banks'
  get :client_tests, '/client/:client_id/tests'
  get :bank, '/bank/:bank_id/view'
  get :bank_items, '/bank/:bank_id/items'
  # delete :delete_bank, 'bank/:id'

  get :test, "/test/:test_id/view"
  get :test_items, "/test/:test_id/items"
  post :create_test_release, "/test/:test_id/release"
  get :test_release, "/test/:test_id/release/:release_id"
  get :test_release_session, "/test/:test_id/release/:release_id/session/:session_id"
  get :test_release_session_results, "/test/:test_id/release/:release_id/session/:session_id/results"
  get :create_test_release_sessions, "/test/:test_id/release/:release_id/sessions/create"
  get :edit_test_release_sessions, "/test/:test_id/release/:release_id/sessions/edit"
  post :edit_test_release, "/test/:test_id/release/:release_id"
  get :test_releases, "/test/:test_id/releases"
  get :test_results, "/test/:test_id/results"
  get :test_session, "/test/:test_id/session/:session_id"
  get :test_release_sessions, "/test/:test_id/sessions/:release_id"
  post :delete_test, "/test/:test_id/delete"
  post :edit_test, "/test/:test_id"

  get :item, "/item/:item_id"
  get :item_screenshot, "/item/:item_id/screenshot"
  get :item_render, "/item/:item_id/render"

end
