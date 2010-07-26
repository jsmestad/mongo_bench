require 'mongo'
require 'logger'

class MongoBench

  DBS_TO_IGNORE = []
  COLS_TO_IGNORE = ['$cmd']

  attr_reader :server, :port, :username, :password

  def initialize(opts)
    @server, @port = opts[:server], opts[:port]
    @username, @password = opts[:username], opts[:password]

    unless @username.nil? && @password.nil?
      connection.add_auth('admin', user, pass)
      connection.apply_saved_authentication
    end
  end

  def run!

  end

  protected

    def connection
      @connection ||= Mongo::Connection.new(@server, @port)
    end

end

