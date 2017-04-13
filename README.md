Basic demonstration of uninterruptible states in native extensions to ruby.

# usage

```
ruby extconf.rb
make
ruby demonstrate.rb
ruby demonstrate_concurrency.rb
```

# sample output

```
testing ruby os sleep
forking
starting block call
3.000963869: got exception Interrupt
3.001365962: fork completing
0.000358466: fork completed. waiting, then interrupting fork
3.000734056: interrupting fork
3.000835772: waiting for fork
3.011042666: everything completed

testing ruby busy sleep
forking
starting block call
2.999848307: got exception Interrupt
2.999899521: fork completing
0.000988675: fork completed. waiting, then interrupting fork
3.001174955: interrupting fork
3.001196978: waiting for fork
3.003973304: everything completed

testing c os sleep
forking
starting block call
3.000986138: got exception Interrupt
3.001323538: fork completing
0.000214165: fork completed. waiting, then interrupting fork
3.000487473: interrupting fork
3.000579227: waiting for fork
3.010584206: everything completed

testing c busy sleep
forking
starting block call
9.860406141: got exception Interrupt
9.860488856: fork completing
0.000883426: fork completed. waiting, then interrupting fork
3.001055798: interrupting fork
3.00109311: waiting for fork
9.864016755: everything completed
```

Note that SIGINT is appropriately interrupting an OS sleep, and a busy loop of Ruby code.
However, it does not interrupt a busy loop that takes place in C code.

sample output of demonstrate\_concurrency.rb

```
testing ruby os sleep
starting threads
5.1932e-05: waiting on threads
starting thread 1
starting thread 2
10.000443724: finished thread 1
10.00030206: finished thread 2
10.000717332: threads done

testing ruby busy sleep
starting threads
0.000285329: waiting on threads
starting thread 2
starting thread 1
busy-slept for 1
busy-slept for 1
busy-slept for 2
busy-slept for 2
busy-slept for 3
busy-slept for 3
busy-slept for 4
busy-slept for 4
busy-slept for 5
busy-slept for 5
busy-slept for 6
busy-slept for 6
busy-slept for 7
busy-slept for 7
busy-slept for 8
busy-slept for 8
busy-slept for 9
busy-slept for 9
busy-slept for 10
10.012047707: finished thread 2
busy-slept for 10
10.000018174: finished thread 1
10.100020619: threads done

testing c os sleep
starting threads
0.000496377: waiting on threads
starting thread 2
starting thread 1
20.000774417: finished thread 2
10.000446722: finished thread 1
20.001522869: threads done

testing c busy sleep
starting threads
0.000159705: waiting on threads
starting thread 1
starting thread 2
19.430273335: finished thread 1
10.000060785: finished thread 2
19.430646684: threads done
```

Note how the ruby busy loops share the GIL, and both do their work simultaneously.
The C busy loops do not share the GIL, and end up doing their work in serial.
