# A Generic Makefile for compiling ROOT programs
# R. Michaels, rom@jlab.org, Aug 2001  See also README !!
# Version of this release
# 
ROOTLIBS      = $(shell root-config --libs)
ROOTGLIBS     = $(shell root-config --glibs)
ROOTINC       = $(shell root-config --incdir)
CXXFLAGS      = -Wall -g -frtti -fexceptions -fPIC \
                   -DLINUXVERS -O

O=eic

# Linux with g++
INCLUDES      = -I$(ROOTSYS)/include -I/opt/local/include -I$(ROOTINC) 
CXX           = clang++
#CXX           = g++
LD            = clang++
#LD            = g++
LDFLAGS       = 

LIBS          = $(ROOTLIBS)  -L/usr/lib/ 
GLIBS         = $(ROOTGLIBS) -L/usr/X11/lib -L/usr/lib/ -lXpm -lX11 

ALL_LIBS =  $(GLIBS) $(LIBS)

# The following sources comprise the package of scaler classes by R. Michaels.
SRC = $(O).C

HEAD = $(SRC:.C=.h)
DEPS = $(SRC:.C=.d)
SCALER_OBJS = $(SRC:.C=.o)

# Test code executibles
PROGS = $(O)

$(O): $(O).o $(O).C
	rm -f $@
	$(CXX) $(CXXFLAGS) $(INCLUDES)  -o $@  $(O).o $(ALL_LIBS)

         
clean:
	rm -f *.o core *~ *.d *.tar $(PROGS)

realclean:  clean
	rm -f *.d

###

.SUFFIXES:
.SUFFIXES: .c .cc .cpp .C .o .d

###Adding the EPS09 code
eps09.o: $(EPS09)/eps09.cxx 
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $(EPS09)/eps09.cxx

%.o:	%.C
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $<

%.d:	%.C
	@echo Creating dependencies for $<
	@$(SHELL) -ec '$(CXX) -MM $(CXXFLAGS) $(INCLUDES) -c $< \
		| sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
		[ -s $@ ] || rm -f $@'

-include $(DEPS)

