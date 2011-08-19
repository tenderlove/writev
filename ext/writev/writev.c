#include <ruby.h>
#include <ruby/io.h>
#include <sys/uio.h>

VALUE rb_IOV_MAX;

static VALUE
rb_io_check_io(VALUE io)
{
    return rb_check_convert_type(io, T_FILE, "IO", "to_io");
}

#define rb_sys_fail_path(path) rb_sys_fail(NIL_P(path) ? 0 : RSTRING_PTR(path))

static VALUE rb_writev(VALUE io, VALUE list)
{
    rb_io_t * fptr;
    struct iovec * iov;
    long i;
    ssize_t written;
    VALUE tmp;

#ifdef IOV_MAX
    if(RARRAY_LEN(list) > IOV_MAX)
#else
    if(RARRAY_LEN(list) > NUM2INT(rb_IOV_MAX))
#endif
	rb_raise(rb_eArgError, "list is too long");

    tmp = rb_io_check_io(io);
    GetOpenFile(tmp, fptr);
    rb_io_check_writable(fptr);

    iov = xcalloc(RARRAY_LEN(list), sizeof(struct iovec));

    for(i = 0; i < RARRAY_LEN(list); i++) {
	VALUE string = rb_ary_entry(list, i);
	iov[i].iov_base = StringValuePtr(string);
	iov[i].iov_len = RSTRING_LEN(string);
    }

    if((written = writev(fptr->fd, iov, (int)RARRAY_LEN(list))) == -1)
	rb_sys_fail_path(fptr->pathv);

    return LONG2FIX(written);
}

void Init_writev()
{
    rb_define_method(rb_cIO, "writev", rb_writev, 1);
#ifdef IOV_MAX
    rb_IOV_MAX = INT2NUM(IOV_MAX);
#else
    rb_IOV_MAX = INT2NUM(sysconf(_SC_IOV_MAX));
#endif
    rb_define_const(rb_cIO, "IOV_MAX", rb_IOV_MAX);
}

/* vim: set noet sws=4 sw=4: */
