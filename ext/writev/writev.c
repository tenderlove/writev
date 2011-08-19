#include <ruby.h>
#include <ruby/io.h>
#include <sys/uio.h>

static VALUE rb_writev(VALUE io, VALUE list)
{
    rb_io_t * fptr;
    struct iovec * iov;
    long i;

    GetOpenFile(io, fptr);
    iov = xcalloc(RARRAY_LEN(list), sizeof(struct iovec));

    for(i = 0; i < RARRAY_LEN(list); i++) {
	VALUE string = rb_ary_entry(list, i);
	iov[i].iov_base = StringValuePtr(string);
	iov[i].iov_len = RSTRING_LEN(string);
    }

    writev(fptr->fd, iov, RARRAY_LEN(list));

    return Qnil;
}

void Init_writev()
{
    rb_define_method(rb_cIO, "writev", rb_writev, 1);
}

/* vim: set noet sws=4 sw=4: */
