require 'sinatra'
require 'wmctrl'
require 'cgi'


WM = WMCtrl.new
CHILDS = []

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
