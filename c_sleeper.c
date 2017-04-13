#include <ruby.h>
#include "extconf.h"
#include <unistd.h>
#include <time.h>
#include <stdio.h>

VALUE os_sleep(VALUE self, VALUE secs) {
	unsigned int sleep_secs = FIX2UINT(secs);
	sleep(sleep_secs);
	return Qnil;
}

VALUE busy_sleep(VALUE self, VALUE secs) {
	/* Obviously, you wouldn't usually write a 'sleep' function like this.
	 * this is a stand-in for a long-running, CPU-intensive calculation */
	unsigned int sleep_secs = FIX2UINT(secs);
	time_t t1,t2;
	time(&t1);
	do {
		time(&t2);
	} while (difftime(t2,t1) < sleep_secs);
	return Qnil;
}

void Init_c_sleeper() {
	rb_define_global_function("c_os_sleep", os_sleep, 1);
	rb_define_global_function("c_busy_sleep", busy_sleep, 1);
}
