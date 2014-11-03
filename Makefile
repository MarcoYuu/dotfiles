PROGRAM_NAME := out

# out
OUT_DIR := build
PROGRAM := $(OUT_DIR)/$(PROGRAM_NAME)

# sources
SOURCE_DIR := src
SOURCES_CPP := $(notdir $(wildcard $(SOURCE_DIR)/*.cpp))
SOURCES_CC := $(notdir $(wildcard $(SOURCE_DIR)/*.cc))
SOURCES_C := $(notdir $(wildcard $(SOURCE_DIR)/*.c))
SOURCES := $(SOURCES_CPP) $(SOURCES_CC) $(SOURCES_C)

# headers
HEADER_DIR := src
HEADERS_HPP := $(notdir $(wildcard $(HEADER_DIR)/*.hpp))
HEADERS_HH := $(notdir $(wildcard $(HEADER_DIR)/*.hh))
HEADERS_H := $(notdir $(wildcard $(HEADER_DIR)/*.h))
HEADERS := $(HEADERS_HPP) $(HEADERS_HH) $(HEADERS_H)

# objs
OBJ_DIR := obj
OBJS := $(addprefix $(OBJ_DIR)/,$(SOURCES_CPP:.cpp=.o))
OBJS += $(addprefix $(OBJ_DIR)/,$(SOURCES_CC:.cc=.o))
OBJS += $(addprefix $(OBJ_DIR)/,$(SOURCES_C:.c=.o))

# dependencies
DEPEND_DIR := obj
DEPENDS := $(addprefix $(DEPEND_DIR)/,$(SOURCES_CPP:.cpp=.d))
DEPENDS += $(addprefix $(DEPEND_DIR)/,$(SOURCES_CC:.cc=.d))
DEPENDS += $(addprefix $(DEPEND_DIR)/,$(SOURCES_C:.c=.d))

# compiler
PACKAGES :=
CXX := g++
CXXFLAGS := -O2 -Wall $(shell if [ -n "$(PACKAGES)" ] ; then pkg-config $(PACKAGES) --cflags; fi)
LIBS := -lGL -lGLU -lglut $(shell if [ -n "$(PACKAGES)" ] ; then pkg-config $(PACKAGES) --libs; fi)

vpath %.cpp src
vpath %.cc src
vpath %.c src
vpath %.hpp src
vpath %.hh src
vpath %.h src

.PHONY: all
all: $(DEPENDS) $(PROGRAM)
$(PROGRAM): $(OBJS)
	@mkdir -p $(OUT_DIR)
	$(CXX) $(CXXFLAGS) -o $(PROGRAM) $^ $(LIBS)

$(DEPEND_DIR)/%.d: %.cpp
	@echo generating $@
	@mkdir -p $(DEPEND_DIR)
	@$(SHELL) -ec '$(CXX) $(CXXFLAGS) $(LIBS) -MM $< | tr "\\\\\n" " " | sed -e "s/^\(.*\)$$/$(OBJ_DIR)\/\1\n\t@mkdir -p $$\(OBJ_DIR\)\n\t$$\(CXX\) $$\(CXXFLAGS\) -c $$< -o $$\@ $$\(LIBS\)/g" > $(DEPEND_DIR)/$(notdir $@)'

$(DEPEND_DIR)/%.d: %.cc
	@echo generating $@
	@mkdir -p $(DEPEND_DIR)
	@$(SHELL) -ec '$(CXX) $(CXXFLAGS) $(LIBS) -MM $< | tr "\\\\\n" " " | sed -e "s/^\(.*\)$$/$(OBJ_DIR)\/\1\n\t@mkdir -p $$\(OBJ_DIR\)\n\t$$\(CXX\) $$\(CXXFLAGS\) -c $$< -o $$\@ $$\(LIBS\)/g" > $(DEPEND_DIR)/$(notdir $@)'

$(DEPEND_DIR)/%.d: %.c
	@echo generating $@
	@mkdir -p $(DEPEND_DIR)
	@$(SHELL) -ec '$(CXX) $(CXXFLAGS) $(LIBS) -MM $< | tr "\\\\\n" " " | sed -e "s/^\(.*\)$$/$(OBJ_DIR)\/\1\n\t@mkdir -p $$\(OBJ_DIR\)\n\t$$\(CXX\) $$\(CXXFLAGS\) -c $$< -o $$\@ $$\(LIBS\)/g" > $(DEPEND_DIR)/$(notdir $@)'

ifneq "$(MAKECMDGOALS)" "clean"
-include $(DEPENDS)
endif

.PHONY : clean
clean:
	rm -rf $(OUT_DIR)
	rm -rf $(OBJ_DIR)
	rm -rf $(DEPEND_DIR)
