require 'writev'
require 'tempfile'
require 'benchmark'

LIST = File.readlines '/usr/share/dict/words'
p LIST.length

Benchmark.bm(7) do |x|
  x.report('write') {
    file = Tempfile.new('write')
    LIST.each { |l| file.write l }
    file.unlink
  }
  x.report('writev') {
    file = Tempfile.new('write1')
    LIST.each_slice(IO::IOV_MAX) do |slice|
      file.writev slice
    end
    file.unlink
  }
end

# /* vim: set et sws=2 sw=2: */
__END__
[aaron@higgins writev (master)]$ ruby -I lib bench.rb
235886
              user     system      total        real
write     0.270000   0.010000   0.280000 (  0.293202)
writev    0.020000   0.040000   0.060000 (  0.087576)
