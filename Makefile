# GNU-compatible toolchain assumed.

PROGS := test_shared_range
all: $(PROGS)

CXXFLAGS += -g -Wall -Wextra -Wunused -ansi -pedantic

check: test_shared_range
	./test_shared_range --log_level=test_suite

check-valgrind: test_shared_range
	valgrind --suppressions=./boosttest.supp           \
	         --num-callers=30                          \
	         --memcheck:leak-check=full                \
	         --memcheck:leak-resolution=high           \
	         --memcheck:show-reachable=yes             \
	         --memcheck:track-origins=yes              \
	         ./test_shared_range --log_level=test_suite

check-coverage: CXXFLAGS += --coverage
check-coverage: clean test_shared_range
	./test_shared_range --log_level=test_suite
	gcov test_shared_range.cpp

test_shared_range.o: CXXFLAGS += -O0
test_shared_range.o: test_shared_range.cpp shared_range.hpp
test_shared_range: CC = $(CXX)
test_shared_range: test_shared_range.o

clean:
	rm -fv $(PROGS) *.o *.gcno *.gcda *.gcov
