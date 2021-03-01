# WOZ "CATALOG"                    / MEMORY  MAP / RAM TYPE / COMP -> DEST
# boot0:    	T00/S00		$0800	    MAIN
# FLOAD:		T00/S01-T00/S0x 	$FC00	   RAMCARD
# MAIN:  		T01/S00-T01/Sxx	$D000	   RAMCARD		
# MUSIC:		T02/S00-T02/SXX	$4000	     MAIN     *  -> $6000
# DONUT:		T03/S00-T22/SXX	$0400	     MAIN


DISKWOZ = test.woz

PYTHON27 = C:\Python27\python.exe
ACME = acme.exe -f plain -o
LZ4 = lz4.exe
ZPACK = zpacker.exe
DSK2WOZ = DSK2WOZ.exe
W2W = W2W.exe
GENWOZ = GENWOZ.exe
DIRECTWRITE = $(PYTHON27) $(A2SDK)\bin\dw.py
INSERTBIN = $(PYTHON27) $(A2SDK)\bin\InsertBIN.py
TRANSAIR = $(PYTHON27) $(A2SDK)\bin\transair.py
GENDSK = $(PYTHON27) $(A2SDK)\bin\genDSK.py
COPYFILES = $(PYTHON27) $(A2SDK)\bin\InsertZIC.py
APPLEWIN = $(APPLEWINPATH)\Applewin.exe -d1

EMULATOR = $(APPLEWIN)

all: $(DISKWOZ)

$(DISKWOZ): floadc.b boot.b main.b data

	$(GENWOZ)  -v -t "0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1"
# boot 		T0 S0 	> $800 (M)
	$(W2W) s p 0 0 $(DISKWOZ) boot.b
# fload 		T0 S1	> $FC00 (LC)
	$(W2W) s p 0 1 $(DISKWOZ) floadc.b
# main.b 		T1 S0 	> $D000 (LC)
	$(W2W) c p 1 0 $(DISKWOZ) main.b
# music		T2 S0	> $4000 (M) * >> $6000 (M)
	$(W2W) c p 2 0 $(DISKWOZ) music\ZICDECOMP.lz4

# DONUT		T3+ S0+ 
	$(W2W) c p 3 0 $(DISKWOZ) DONUT\donut.bin
	
# 	EMULATOR
	copy lbl_main.txt $(APPLEWINPATH)\A2_USER1.SYM
	$(EMULATOR) $(DISKWOZ)

boot.b: boot.a floadc.a
	$(ACME) boot.b boot.a

floadc.b: floadc.a
	$(ACME) floadc.b floadc.a

main.b: main.a floadc.a
	$(ACME) main.b main.a

data: DONUT\donut.bin

clean:
	del *.b
	del lbl_*.txt
