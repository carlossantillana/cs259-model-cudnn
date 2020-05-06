NVCC=nvcc
ARCH?=sm_70
CUDA_PATH?=/usr/local/cuda-10.1

NVCCHEADERS := -I $(CUDNN_PATH)/include 
NVCCLIBS := -L$(CUDNN_PATH)/lib64 -L/usr/local/lib -lcudart 
TARGET_EXEC ?= yalsa

BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

SRCS := $(shell find $(SRC_DIRS) -name *.cu)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -g 

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CUDA_PATH)/bin/$(NVCC) $(OBJS) -o $@ $(LDFLAGS)

# c source
#
#$(BUILD_DIR)/%.c.o: %.c
#	$(MKDIR_P) $(dir $@)
#	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
#$(BUILD_DIR)/%.cpp.o: %.cpp
#	$(MKDIR_P) $(dir $@)
#	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# cuda source
$(BUILD_DIR)/%.cu.o: %.cu
	$(MKDIR_P) $(dir $@)
	$(CUDA_PATH)/bin/$(NVCC) $(NVCCHEADERS) $(NVCCLIBS) -c $< -o $@ -std=c++11 



.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p

