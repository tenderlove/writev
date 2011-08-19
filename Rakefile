# -*- ruby -*-

require 'rubygems'
require 'hoe'

gem 'rake-compiler', '>= 0.4.1'
require "rake/extensiontask"

Hoe.plugins.delete :rubyforge
Hoe.plugin :minitest
Hoe.plugin :gemspec   # `gem install hoe-gemspec`
Hoe.plugin :git       # `gem install hoe-git`
Hoe.plugin :debugging # `gem install hoe-debugging`

Hoe.spec 'writev' do
  developer('Aaron Patterson', 'aaron@tenderlovemaking.com')
  self.readme_file   = 'README.rdoc'
  self.history_file  = 'CHANGELOG.rdoc'
  self.extra_rdoc_files  = FileList['*.rdoc']

  extra_dev_deps << ['rake-compiler', '>= 0.4.1']

  self.spec_extras = {
    :extensions            => ["ext/writev/extconf.rb"],
    :required_ruby_version => '>= 1.9.2'
  }

  Rake::ExtensionTask.new "writev", spec do |ext|
    ext.lib_dir = File.join(*['lib', ENV['FAT_DIR']].compact)
  end
end

# vim: syntax=ruby
