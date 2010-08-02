require 'mongo'
require 'logger'

class MongoBench

  DBS_TO_IGNORE = []
  COLS_TO_IGNORE = ['$cmd']

  attr_reader :threads, :server, :port, :username, :password, :db, :iter

  def initialize(opts)
    @threads = opts[:threads]
    @server, @port = opts[:server], opts[:port]
    @username, @password = opts[:username], opts[:password]
    @db = opts[:db]
    @file = opts[:file]
    @iter = 10000

    if @username && @password
      puts "adding auth for #{username}/#{password} to admin"
      connection.add_auth('admin', @username, @password)
      connection.apply_saved_authentication
    end
  end

  def run!
    puts "running"

    js = IO.read(@file)
    @threads.times do 
      db=connection.db(@db)
      Thread.new do
        @iter.times do 
          db.eval(js)
        end
      end
    end
  end

  protected

    def connection
      @connection ||= Mongo::Connection.new(@server, @port)
    end

end

