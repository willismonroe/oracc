include ../../../oracc-am-rules.txt
AM_CFLAGS=-ansi -pedantic -Wall -g -std=c99
SUBDIRS=
noinst_LTLIBRARIES=librun.la

librun_la_SOURCES = \
	run.c

AM_CPPFLAGS=-I@top_srcdir@/c/include \
	-I@top_srcdir@/c/otf/{chr,gdl,lib,lng,prj} \
	-I@top_srcdir@/c/l2/include

EXTRA_DIST=run.h
