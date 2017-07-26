require "./auth-api/*"
require "socket"
require "openssl"

# TODO: SSL
class Auth::Api
  @socket : TCPSocket
  @ip : String
  @port : UInt16
  @ssl : Bool
  @ssl_socket : OpenSSL::SSL::Socket::Client?
  @verbosity : Bool
  property username : String
  property password : String
  getter authenticated : Bool
  getter last_result : String

  def initialize(@ip = "127.0.0.1", @port = 8999_u16, @username = "root", @password = "toor", @ssl = false, @verbosity = false)
    @socket = TCPSocket.new(@ip, @port)
    @ssl_socket = nil
    STDOUT.puts "Connected to #{@ip}:#{@port}@#{@username}:******" if @verbosity
    if @ssl
      ssl_context = OpenSSL::SSL::Context::Client.insecure
      # TODO. well, it should only be used for testing
      ssl_context.verify_mode = OpenSSL::SSL::VerifyMode::NONE
      @ssl_socket = OpenSSL::SSL::Socket::Client.new(@socket, ssl_context)
      STDOUT.puts "Secure connection established" if @verbosity
    end
    @authenticated = false
    @last_result = ""
  end

  def socket
    @ssl_socket || @socket
  end

  private def gets
    result = socket.gets
    STDOUT.puts "< #{result.inspect}" if @verbosity
    if result.nil?
      socket.close
      STDOUT.puts "End of connection" if @verbosity
    else
      @last_result = result
    end
    return result
  end

  private def puts(data)
    socket.puts data
    socket.flush
    STDOUT.puts "> #{data.inspect}" if @verbosity
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
