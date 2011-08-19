require 'writev'
require 'tempfile'
require 'benchmark'

def avg items
  items.map { |item| item.length }.inject(:+) / items.length
end

def make_strings count, min, spread
  strings = []

  open '/dev/zero' do |io|
    while strings.length < count do
      strings << io.read(min + rand(spread))
    end
  end

  strings
end

def bench list
  p :length => list.length
  p :avg_size => avg(list)

  Benchmark.bm(13) do |x|
    x.report('write') {
      Tempfile.open 'write' do |file|
        list.each { |l| file.write l }
      end
    }

    x.report('write join') {
      Tempfile.open 'write' do |file|
        file.write list.join
      end
    }

    x.report('syswrite') {
      Tempfile.open 'write' do |file|
        list.each { |l| file.syswrite l }
      end
    }

    x.report('syswrite join') {
      Tempfile.open 'write' do |file|
        file.syswrite list.join
      end
    }

    x.report('writev') {
      Tempfile.open 'write' do |file|
        list.each_slice(IO::IOV_MAX) do |slice|
          file.writev slice
        end
      end
    }
  end

  puts
end

list = File.readlines '/usr/share/dict/words'

bench list

list = make_strings list.length, 1024, 1024

bench list

list = make_strings (list.length / 4), 10240, 10240

bench list

# /* vim: set et sws=2 sw=2: */
__END__
{:length=>235886}
{:avg_size=>10}
                    user     system      total        real
write           0.150000   0.010000   0.160000 (  0.168736)
write join      0.020000   0.000000   0.020000 (  0.020665)
syswrite        0.390000   0.500000   0.890000 (  0.883507)
syswrite join   0.010000   0.000000   0.010000 (  0.018780)
writev          0.030000   0.030000   0.060000 (  0.051839)

{:length=>235886}
{:avg_size=>1535}
                    user     system      total        real
write           0.330000   0.700000   1.030000 (  5.380344)
write join      0.160000   0.450000   0.610000 (  5.489569)
syswrite        0.430000   1.180000   1.610000 (  5.433381)
syswrite join   0.140000   0.490000   0.630000 (  5.723345)
writev          0.020000   0.300000   0.320000 (  5.411284)

{:length=>58971}
{:avg_size=>15372}
                    user     system      total        real
write           0.180000   1.120000   1.300000 ( 13.305516)
write join      0.360000   1.230000   1.590000 ( 15.051602)
syswrite        0.160000   1.120000   1.280000 ( 14.246432)
syswrite join   0.280000   1.280000   1.560000 ( 15.344061)
writev          0.000000   0.680000   0.680000 ( 14.185484)

