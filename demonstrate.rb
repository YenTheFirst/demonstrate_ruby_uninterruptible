require './c_sleeper'

def timed_fork
  t1 = Time.now
  puts "forking"
  pid = fork do
    inner_t1 = Time.now
    puts "starting block call"
    begin
      yield 10
      puts "#{Time.now - inner_t1}: block call completed"
    rescue Exception => e
      puts "#{Time.now - inner_t1}: got exception #{e.class}"
    end
    puts "#{Time.now - inner_t1}: fork completing"
  end

  puts "#{Time.now - t1}: fork completed. waiting, then interrupting fork"
  sleep(3)
  puts "#{Time.now - t1}: interrupting fork"
  Process.kill("INT", pid)
  puts "#{Time.now - t1}: waiting for fork"
  Process.wait(pid)
  puts "#{Time.now - t1}: everything completed"
end


puts "testing ruby os sleep"
timed_fork {|n| sleep(n)}
puts ""

puts "testing ruby busy sleep"
timed_fork do |n|
  t1 = Time.now
  t2 = t1
  t2 = Time.now until t2-t1 > n
end
puts ""

puts "testing c os sleep"
timed_fork {|n| c_os_sleep(n)}
puts ""

puts "testing c busy sleep"
timed_fork {|n| c_busy_sleep(n)}
puts ""
