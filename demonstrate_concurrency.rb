require './c_sleeper'

def thread_two
  t1 = Time.now
  puts "starting threads"

  threads = [1,2].map do |n|
    Thread.new(n) do |n|
      inner_t1 = Time.now
      puts "starting thread #{n}"
      yield(10)
      puts "#{Time.now - inner_t1}: finished thread #{n}"
    end
  end

  puts "#{Time.now - t1}: waiting on threads"
  threads.each(&:join)
  puts "#{Time.now - t1}: threads done"
end

puts "testing ruby os sleep"
thread_two {|n| sleep(n)}
puts ""

puts "testing ruby busy sleep"
thread_two do |n|
  t1 = Time.now
  t2 = t1
  last_diff = (t2-t1).to_i
  until t2 - t1 > n
    t2 = Time.now
    diff = (t2-t1).to_i
    puts "busy-slept for #{diff}" if diff > last_diff
    last_diff = diff
  end
end
puts ""

puts "testing c os sleep"
thread_two {|n| c_os_sleep(n)}
puts ""

puts "testing c busy sleep"
thread_two {|n| c_busy_sleep(n)}
puts ""
