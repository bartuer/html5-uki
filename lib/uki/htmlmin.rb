require 'rubygems'
require 'nokogiri'
require 'open3'
require 'open-uri'

module Nokogiri
  module HTML
    class Document
      def remove_dev_link
        jspec_min_css_link = self.xpath('//head/link[@type = "text/css" and @href="/stylesheets/jspec_min.css"]').first
        jspec_css_link = self.xpath('//head/link[@type = "text/css" and @href="/stylesheets/jspec.css"]').first
        dev_bundle_link = self.xpath('//body/script[@src = "/javascripts/dev.bundle.js"]').first
        jspec_css_link.unlink if jspec_css_link
        jspec_min_css_link.unlink if jspec_min_css_link
        dev_bundle_link.unlink if dev_bundle_link
      end

      def replace_css_link_with_minify_content(url)
        css_links = self.xpath('//head/link[@type = "text/css"]')
        css_links.each { |css_link|
          if css_link['href'].match(/http:\/\//)
            css_url = css_link['href']
          else
            css_url = url + css_link['href']
          end
          stylesheet_content = open(css_url)
          Open3.popen3('css_minify') { |i, o, e|
            i.puts stylesheet_content.read
            i.close
            stylesheet = Nokogiri::HTML::Document.new.fragment(<<-eofstyle)
<style type="text/css" media="screen">
#{o.read}
</style>
eofstyle
            css_link.before stylesheet.to_html
          }
          css_link.unlink
        }
      end

      def replace_dynamical_js_link
        js_links = self.xpath('//body/script')
        js_links.each { |js_link|
          if js_link['src'].match(/(.i)?(.[yguz])?\.cjs$/)
            src = js_link['src']
            static_link = Nokogiri::HTML::Document.new.fragment(<<-eofjslink)
<script src="#{src.gsub(/http.*\/javascripts/,'/javascripts').gsub(/\.i\./,'.').gsub(/\.[ugyz]\./, '.').gsub(/\.cjs$/, '.js')}">
</script>
eofjslink
            js_link.before static_link.to_html
            js_link.unlink
          end
        }
      end

      def minify_html
        Open3.popen3("tidy -q -wrap 10000 -utf8|sed -e 's+<meta name=\"generator\".*$++g'|awk 'BEGIN {ORS=\"\"}{print}'") { |i,o,e|
          i.puts self.to_html(:encoding => 'UTF-8', :indent => 0)
          i.close
          o.gets
        }
      end

      def to_minify_html(url='http://localhost', replace_css=true)
        remove_dev_link
        replace_css_link_with_minify_content url if replace_css
        replace_dynamical_js_link
        minify_html
      end
    end
  end
end
