Basic demonstration of uninterruptible states in native extensions to ruby.

# usage

```
ruby extconf.rb
make
ruby demonstrate.rb
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
