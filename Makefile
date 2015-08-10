APP_NAME=hello_world
# binary|library
APP_TYPE=binary
APP_VERS=0.1

CC=mpicc
CFLAGS=-O3 -Wall -DNDEBUG -std=c99 -g $(OPTFLAGS)

ifeq ($(APP_TYPE), library)
CFLAGS+=-fPIC
endif

LIBS=$(OPTLIBS)
#PREFIX?=/usr/local

SOURCES=$(wildcard src/**/*.c src/*.c)
OBJECTS=$(patsubst %.c,%.o,$(SOURCES))

TEST_SRC=$(wildcard tests/*_tests.c)
TESTS=$(patsubst %.c,%,$(TEST_SRC))

TARGET=bin/$(APP_NAME)-$(APP_VERS)
LD_TARGET=bin/lib$(APP_NAME)-$(APP_VERS).a
SO_TARGET=$(patsubst %.a,%.so,$(LD_TARGET))

# The Target Build
all: $(TARGET) $(LD_TARGET) $(SO_TARGET)

dev: CFLAGS=-g -O0 -Wall -Wextra $(OPTFLAGS)
dev: all

$(TARGET): dirs $(OBJECTS)
ifeq ($(APP_TYPE), binary)
	$(CC) -o $@ $(OBJECTS)
endif

$(LD_TARGET): dirs $(OBJECTS)
ifeq ($(APP_TYPE), library)
	ar rcs $@ $(OBJECTS)
	ranlib $@
endif

$(SO_TARGET): $(LD_TARGET) $(OBJECTS)
ifeq ($(APP_TYPE), library)
	$(CC) -shared -o $@ $(OBJECTS)
endif

dirs:
	@mkdir -p bin

# The Unit Tests
.PHONY: tests
tests: CFLAGS += $(LD_TARGET)
tests: $(TESTS)
	sh ./tests/runtests.sh

valgrind:
	VALGRIND="valgrind --log-file=/tmp/valgrind-%p.log" $(MAKE)

# The Cleaner
clean:
	rm -rf bin $(OBJECTS) $(TESTS)
	rm -f tests/tests.log
	find . -name "*.gc*" -exec rm {} \;
	rm -rf `find . -name "*.dSYM" -print`

# The Install
install: all
	install -d $(DESTDIR)/$(PREFIX)/lib/
	install $(LD_TARGET) $(DESTDIR)/$(PREFIX)/lib/

# The Checker
BADFUNCS='[^_.>a-zA-Z0-9](str(n?cpy|n?cat|xfrm|n?dup|str|pbrk|tok|_)|stpn?cpy|a?sn?printf|byte_)'
check:
	@echo Files with potentially dangerous functions.
	@egrep $(BADFUNCS) $(SOURCES) || true
