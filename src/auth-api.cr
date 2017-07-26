require "./auth-api/*"
require "socket"

# TODO: SSL
class Auth::Api
  @socket : TCPSocket
  @ip : String
  @port : UInt16
  property username : String
  property password : String
  getter authenticated : Bool
  getter last_result : String

  def initialize(@ip = "127.0.0.1", @port = 8999_u16, @username = "root", @password = "toor", verbose = false)
    @socket = TCPSocket.new(@ip, @port)
    STDOUT.puts "Connected to #{@ip}:#{@port}@#{@username}:******" if verbose
    @authenticated = false
    @last_result = ""
  end

  private def gets(verbosity = false)
    result = @socket.gets
    if result.nil?
      @socket.close
      STDOUT.puts "End of connection" if verbosity
    else
      @last_result = result
    end
    return result
  end

  private def puts(data)
    @socket.puts data
  end

  SUCCESS = "success"
  FAILURE = "failure"

  def success?
    @last_result.starts_with? SUCCESS
  end

  def auth! : Bool
    puts "AUTH : #{@username} #{@password}"
    gets
    self.success?
  end

  def has_access_to?(path, perm = "write") : Bool
    puts "USER HAS ACCESS TO : #{perm} #{path}"
    gets
    self.success?
  end
end
