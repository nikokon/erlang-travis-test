# File   : Makefile
# Author : Tommy Mattsson, tommy.mattsson@gmail.com
# Sources: http://stackoverflow.com/questions/1667597/erlang-emakefile-explain
#	   http://willcodeforfoo.com/2009/07/10/erlang-makefile/
#	   http://www.wlug.org.nz/MakefileHowto

MODULE = main
FUNC = start
ARG1 = "default"
ARG2 = regular

# Builds the application
all: ebin compile
start: all start_app

ebin:
	@mkdir ebin

compile:
	@erl -make

# Starts the application
# start_app:
#	Starts an erlang node with a shell, prepends ebin to the code path (see
# 	"man erl" documentation for details) ans starts module main and function
#	start
#	erl -pa ebin -s $(MODULE) $(FUNC) $(ARG1) $(ARG2)

clean:
	rm -rf *.beam
	rm -rf *.dump
	rm -rf doc/*.beam
	rm -rf doc/*.dump
	rm -rf ebin/
	rm -rf include/*.beam
	rm -rf include/*.dump
	rm -rf scripts/*.beam
	rm -rf scripts/*.dump
	rm -rf src/*.beam
	rm -rf src/*.dump

clean_all: clean
	rm -rf *~
	rm -rf doc/*~
	rm -rf include/*~
	rm -rf scripts/*~
	rm -rf src/*~

.PHONY: all clean
