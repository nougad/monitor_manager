require 'sinatra/base'
require 'wmctrl'
require 'cgi'


WM = WMCtrl.new
CHILDS = []

class MonitorManager < Sinatra::Base
  settings.root = File.dirname(File.dirname(File.dirname(__FILE__)))


  get '/' do
    @desktops = WM.list_desktops rescue []
    @windows = WM.list_windows(true) rescue []
    @windows.each do |window|
      window[:comm] = File.read("/proc/#{window[:pid]}/comm")
      window[:cmdline] = File.read("/proc/#{window[:pid]}/cmdline")
      window[:fullscreen] = (window[:state] || []).include?("_NET_WM_STATE_FULLSCREEN")
    end

    erb :home
  end

  post '/activate/:id' do
    windows = WM.list_windows rescue []
    window = windows.find{|window| window[:id] == params[:id].to_i}
    WM.switch_desktop(window[:desktop]) rescue nil if window
    WM.action_window(params[:id].to_i) rescue nil
    redirect back
  end

  post '/close/:id' do
    WM.action_window(params[:id].to_i, :close) rescue nil
    redirect back
  end

  post '/fullscreen/:id' do
    WM.action_window(params[:id].to_i,:change_state, "toggle", "fullscreen") rescue nil
    redirect back
  end

  post '/activate_desktop/:id' do
    WM.switch_desktop(params[:id].to_i) rescue nil
    redirect back
  end

  post '/activate_desktop' do
    WM.switch_desktop(params[:id].to_i) rescue nil
    redirect back
  end

  post '/command' do
    CHILDS << fork do
      exec params[:command]
    end
    redirect back
  end


  post '/browse' do
    CHILDS << fork do
      url = params[:url]
      url = "http://www.youtube.com/v/#{$1}?autoplay=1&loop=1" if url =~ /youtube\.com\/.*v=([^\?]+)/
      exec %{google-chrome --kiosk "#{url}"}
    end

    redirect back
  end


  if ARGV.any?
      require 'optparse'
      OptionParser.new { |op|
        op.on('-p port',   'set the port (default is 4567)')                { |val| set :port, Integer(val) }
        op.on('-o addr',   'set the host (default is 0.0.0.0)')             { |val| set :bind, val }
        op.on('-e env',    'set the environment (default is development)')  { |val| set :environment, val.to_sym }
        op.on('-s server', 'specify rack server/handler (default is thin)') { |val| set :server, val }
        op.on('-x',        'turn on the mutex lock (default is off)')       {       set :lock, true }
      }.parse!(ARGV.dup)
    end

end
require 'monitor_manager/version'
