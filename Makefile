
OBJECT 	= obj/test.o obj/io_kernal.o obj/load.o
BINARY 	= bin/test.prg
TESTS 	= obj/bank_access_simple.o obj/bank_access_overflow.o obj/bank_access_other.o obj/bank_execute.o obj/read_back_direct_1.o obj/read_back_direct_2.o obj/read_back_indirect_1.o obj/read_back_indirect_2.o

all: 	$(OBJECT) $(TESTS) $(BINARY)

bin/test.prg: obj/test.o obj/io_kernal.o obj/load.o $(TESTS)

obj/%.o: src/%.asm src/defs.inc
	ca65 -t pet $< -o $@

obj/%.o: test/%.asm src/defs.inc
	ca65 -t pet $< -o $@

bin/%.bin: 
	ld65 $^ -C cfg/$*_bin.cfg -o $@

bin/%.prg:
	ld65 $^ -C cfg/$*_prg.cfg -o $@

.PHONY: clean disk copy install

disk:	bin/disk.d80

bin/disk.d80: bin/test.prg
	c1541 -format test,01 d80 bin/test.d80 -write bin/test.prg test

copy:	bin/test.prg
	cp bin/test.prg bin/TEST
	cd bin && cbmlink -c serial COM1 -fw TEST
	rm bin/TEST

clean:
	rm -f obj/*.o bin/*.bin bin/*.prg bin/*.d80

