require "rubygems"
require "tilt/erb"
require "bundler/setup"
Bundler.require(:default)
require 'sinatra/base'
require "sinatra/reloader"

class CacheController < Sinatra::Base

  use Rack::ETag

  configure do
    enable :sessions
    enable :inline_templates

    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file

    set :raise_errors, true
    register Sinatra::Reloader
  end

  get '/' do
    sleep 1
    #cache_control :public, :must_revalidate, :max_age => 60
    erb :index, :locals => { :message => "Hello" }
  end
  
  def json_data(data={},callback=nil)
    now = Time.now
    data[:color] = ((now.sec/10) % 2 == 0 ? "red" : "blue")
    resp = data.to_json
    resp = "#{params["callback"]}(#{response})" if params["callback"]
    resp
  end
  
  get '/data.json' do
    content_type :json
    #cache_control :public, :must_revalidate, :max_age => 10
    #cache_control :nocache
    sleep (params[:delay].to_i || 0)
    data = {}
    cookie = request.cookies['cookie']
    data[:cookie] = cookie if cookie
    json_data(data, params[:callback])
  end
  
  get '/cookie' do
    value = (params["cookie"] || "cookie")
    response.set_cookie "cookie", { :value => value, :max_age => 60*60*24*7 }
    erb :cookie, :locals => { :message => value }
  end
  
  delete '/cookie' do
    cookies.clear
  end

  not_found do
    "Can't find this page"
  end
  
  error 500 do
    "This is a 500 error"
  end
end

__END__
@@ layout
<html>
<head><title>CacheController</title></head>
<body>
  <%= yield %>
</body>
</html>

@@ index
<h1><%= message %></h1>

@@ cookie
<h1>COOKIES TASTE LIKE <%= message.upcase %></h1>
<p>(okay the cookie was specifically set to "<%= message %>")</p>
<pre>
                                    .,.
                                ,nMMMMMMb.
                     .,,,.     dP""""MMMMMb            -
                  .nMMMMMMMn. `M     MMMMMM>
                 uMMMMMMMMMMMb Mx   uMMMMMM   . .,,.
                 MMMMMMP" '"4M.`4MMMMMMMMM' ?J$$$$ccc"=
                 MMMMMM     4M'  "4MMMMP" z$c,"?$c,""$c$h=
                 "MMMMMb,..,d' hdzc   ,cc$$$$$$$$$$L.$c "
     c"`          `4MMMMMMP" ,$$$$$$c,$$$$$$$$$$$$"?? ,c?$.
                 ,cc,.  .,zc$$$$$3?$?$P"?  " "  "    $$$$h`           -
              ,c$$$", c$$$$$$$$PP                   ,$$$$$c
              )$$$$$$$P"$$$$$"  "                   $c,"$c/     *
    '       ,cc$$$$$"".d$?? "                      J$$hc$=
           ,c" d$$??c="         '!!               z$$$$$??
=         `??-$""? ?"             '   .          d$$$""$ccc
            =`" "        "                     ,d$$$$P $$$"-
              d$$h.        ,;!               ,d$$$$P" .$$$h.     =
             <L$$$$c     <!!!!>.         !> -$$$$$P zd$$$""$.
              " "$" $c  !  `!,!'!;,,;!--!!!! `$$P .d$$$$$h $c"
                 $ d$".`!!  `'''`!!!!    !!,! $C,d$$$$$$$$.`$-
        "        $."$ '  ,zcc=cc ``'``<;;!!!> $?$$$$$$$$"$$F"
                 "=" .J,??"" .$",$$$$- '!'!!  $<$$$$$$$$h ?$=.
                 ".d$""",chd$$??""""".r >  !'.$?$$$$$$$$"=,$cc,      #
               ,c$$",c,d$$$"' ,c$$$$$$"'!;!'.$F.$$$$$$$$. $$$."L
              d $$$c$$$$$" ,hd$$$$??" z !!`.P' `$$$$$$$?? $$$P ..
           ,cd J$$$$$$$P',$$$$$$".,c$$" `.d$h h $$$$$$P"?.?$$ ,$$""
          c$$' $$$$$$$C,$$$$$$"',$$$P"z $$$$"-$J"$$$$$ ,$$?$F.$L?$$L
         ,$",J$$$$$$$$$$$$$$"  ,$$$C,r" $$$$$$$"z$$$$$$$$$,`,$$"d$$??
        .dF $$$$$$$$$$$$$$P" $$$$$$$F.-,$$$$$$$$$$$$$$$$$$$%d$$F$$$$cc,-
       ,$( c$$$$$$$$$$$$$$h,c$$$$$$c=".d$$   """',,.. .,.`""?$$$$$$.`?c .
       d$$.$$$$$$$$$$$$$$$$$$$P""P" ,c$$$$$c,"=d$$$$$h."$$$c,"$$$$$$. $$c
      $$$$$$$$$$$$$$$$$$$$$P"",c"  ,$$$$$$$$$h. `?$$$$$$$$$$P'.""`?$$.3$cr
    z$$$$$$$$$ 3?$$$$$$$$$ccc$P   ,$$$$$$$$$$$$$h.`"$$$$$$$$$c?$c .`?$$$$c
  dd$$"J$$$$$$$P $$$$$$$$F?$$$" .d$$$$$$$$$$$$$$$$L.`""???$$$$$$$$$c  ?$C?
 c$$$$ $$3$$$$$$ `$$$$$h$$P"".. $$$$$$$$$$$$$$$??""" ,ccc3$$$$$$$$$ hL`?$C
h$$$$$>`$$$$$$$$$.$$$$$??',c$"  $$$$$P)$$$$$P" ,$$$$$$$$$$$$$$$$$$$ "$ ."$
$$$$$$h.$C$$$$$$$$$$$ccc$P"3$$ ,$$$$$ "$$$P" =""',d$$???""',$$$$$$$$ $cc "
$$$$$$$$$$$$$$$$P$$?$$$.,c??",c$$$$$L$J$P"  zchd$$$$,ccc$$$$$$$$$$$$$$$$
$$$$$$$$$$$$$$$$$$$$3$$$F" c$$$$$$$$$$  ,cc$$$$$$P"""""`"""??$$$$$$$$$$$P/
$$$$$$$$$$$$$$$??)$$$JC".d$$4?$$$$$$$$$c .,c=" .,,J$$$$$$$$hc,J$$$$$$$$$$%
$$$$$$$$$$$$"".,c$$$$CF $$$h"d$$$$$$$$$h "',cd$????$$$$$$$$$$$$$$$$$$$$$$z
$$$$$$$$$P??"3$$P??$$" ,$$$FJ?$$$$$$$$$$cc,,. ,,.  =$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$hc$$$$$r$P"'  $$$$."-3$$$$$$$$$$$$$"$"$$$c, ""????$$$$$$$$$$$$$$$
$$$$$3$$$$$$$h.zccc$$ ,$$$$L`,$$$$$$$$$$$$$L,"- $$$$$cc -cc??)$$$$$$$$$$$$
</pre>

