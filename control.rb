#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'compass-colors'
require 'fancy-buttons'

set :haml, {:format => :html5 }

set :host, "0.0.0.0"

$debug = false
if $debug
  require 'irb'
  require 'irb/completion'
end

error do
	err = request.env['sinatra.error']
	s = []
	s << err.to_s
	s += err.backtrace
	["Application Error", s].flatten.join("<br />")
end

before do
  @js_lib = "/javascripts/jquery-1.4.2.min.js"
  # Sass::Plugin.options[:line_comments] = true
  @title  = "Total Practice IT, LLC - Server Control"
end

get "/" do
  @server_name = `uname -n`
  @stats       = `uptime`
  @mdstats     = `cat /proc/mdstat`
  haml :index
end

get "/reboot/YitIlYup9Guc" do
  @server_name = `uname -n`
#  @results = `shutdown -r now`
  @results = "...rebooting now"
  haml :reboot
end

get "/shutdown/YitIlYup9Guc" do
  @server_name = `uname -n`
#  @results = `shutdown -h now`
  @results = "...shutting down now"
  haml :reboot
end


get "/about" do
  @title = "Total Practice IT: About Us"
  haml :about
end

helpers do
  def option(value, model_value=nil)
    if model_value && model_value == value
      %Q[<option value="#{value}" selected="selected">#{value}</option>]
    else
      %Q[<option value="#{value}">#{value}</option>]
    end
  end
  
  def grid_debug
    return "" unless $debug
    %Q{<script type="text/javascript">
          $(document).ready(function() {
            $("body").append("<div id='debug'>turn grid: <a href='' id='togglegrid'>" + gridstate() + "</a></div>");
            $("#debug").css("position", "absolute");
            $("#debug").css("bottom", "0");
            $("#togglegrid").click(toggle_grid);
          });

          function toggle_grid () {
            $(".container").toggleClass("showgrid");
            $("#togglegrid").text(gridstate());
            return false;
          }

          function gridstate () {
            if ($(".container").hasClass("showgrid")) {
              return 'off';
            } else {
              return 'on';
            };
          }
    </script>
}
  end

  def checkbox(options, checked=false)
    start = "<input"
    start += " checked" if checked
    options.merge!({:type => "checkbox"})
    opts = options.map { |h,k| "#{h}='#{k}'" }
    [start, opts, "/>"].flatten.join(" ")
  end
  
end
