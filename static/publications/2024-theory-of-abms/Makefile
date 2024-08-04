CC:=latexmk
OPTIONS:=-pdf
TARGET:=main

all:
	$(CC) $(OPTIONS) $(TARGET)

clean:
	rm -f $(TARGET).aux
	rm -f $(TARGET).bbl
	rm -f $(TARGET).blg
	rm -f $(TARGET).dvi
	rm -f $(TARGET).fdb_latexmk
	rm -f $(TARGET).log
	rm -f $(TARGET).out
	rm -f $(TARGET).pdf
	rm -f $(TARGET).fls

fresh: clean all
