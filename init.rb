require 'redmine'
#require 'dispatcher'

Redmine::Plugin.register :redmine_embedded_video do
 name 'Redmine Embedded Video'
 author 'Nikolay Kotlyarov, PhobosK, Jan Pilz, 42pub'
 description 'Embeds attachment videos, video URLs or Youtube videos. Usage (as macro): video(ID|URL|YOUTUBE_URL). videojs'
 url 'http://www.redmine.org/issues/5171'
 version '0.0.4.1'
end

Redmine::WikiFormatting::Macros.register do
   desc "Wiki video embedding"

    macro :video do |o, args|
        @width = args[1].gsub(/\D/,'') if args[1]
        @height = args[2].gsub(/\D/,'') if args[2]
        @width ||= 400
        @height ||= 300
        @num ||= 0
        @num = @num + 1
        attachment = o.attachments.find_by_filename(args[0]) if o.respond_to?('attachments')

        if attachment
            file_url = url_for(:only_path => false, :controller => 'attachments', :action => 'download', :id => attachment, :filename => attachment.filename)
        else
            file_url = args[0].gsub(/<.*?>/, '').gsub(/&lt;.*&gt;/,'')
        end
out = <<END
<link href="https://vjs.zencdn.net/7.17.0/video-js.css" rel="stylesheet" />
<script src="https://vjs.zencdn.net/7.17.0/video.min.js"></script>
<video controls preload="auto" id="video_#{@num}" class="video-js" width="#{@width}" height="#{@height}">
    <source src="#{file_url}" type="video/mp4" />
</video>
END

    out.html_safe
  end
end
