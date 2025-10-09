# =========================================
#  General Makefile for Flex + Bison (Windows/Linux)
# =========================================

# Prevent make from using built-in yacc rule
.SUFFIXES:

# ---- CONFIG ----
PROJECT    ?= calc		 # 👈 change this to your base name if needed
LEX_FILE   ?= $(PROJECT).l
YACC_FILE  ?= $(PROJECT).y

CC         = gcc
CFLAGS     ?= -Wall -g
LIBS       ?= 

# ---- GENERATED FILES ----
LEX_OUT    = lex.yy.c
YACC_C     = $(PROJECT).tab.c
YACC_H     = $(PROJECT).tab.h
EXEC       = $(PROJECT)

# ---- RULES ----
all: $(EXEC)

$(EXEC): $(YACC_C) $(LEX_OUT)
	$(CC) $(CFLAGS) -o $(EXEC).exe $(YACC_C) $(LEX_OUT) $(LIBS)

$(LEX_OUT): $(LEX_FILE)
	flex $(LEX_FILE)

$(YACC_C): $(YACC_FILE)
	bison -d $(YACC_FILE)

# ---- CLEAN ----
clean:
	@echo Cleaning up...
	del /Q $(LEX_OUT) $(YACC_C) $(YACC_H) $(EXEC).exe 2>nul || exit 0

# ---- RUN ----
run: all
	./$(EXEC).exe

# ---- REBUILD ----
rebuild: clean all

# ---- HELP ----
help:
	@echo "Usage:"
	@echo "  make PROJECT=name     -> build project"
	@echo "  make run              -> build & run"
	@echo "  make clean            -> remove generated files"
	@echo "  make rebuild          -> clean and rebuild everything"