
namespace :doc do
   desc "Publishes documentation to your Github Pages"
   task :publish => [:manual, :yard] do
      require 'tmpdir'
      
      ROOT = File.expand_path("#{File.dirname(__FILE__)}/../")

      current_branch = `git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/'`.strip
      
      Dir.mktmpdir do |dir|
	 FileUtils.cp_r("#{ROOT}/doc/manual", dir)
         FileUtils.cp_r("#{ROOT}/doc/plugin", dir)

         system "cd #{ROOT}"
         system "git checkout gh-pages"
         system "git rm -r manual"
         system "git rm -r yard"
         
	 FileUtils.rm_r("#{ROOT}/doc")
	 FileUtils.cp_r("#{dir}/manual", "#{ROOT}/manual")
         FileUtils.cp_r("#{dir}/plugin", "#{ROOT}/yard")

         system "git add manual/*"
         system "git add yard/*"

         system "git commit -m 'publish new pages from #{current_branch}'"
         system "git push origin gh-pages"
         system "git checkout #{current_branch}"
      end
   end
end
