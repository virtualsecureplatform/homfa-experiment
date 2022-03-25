cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(trgsw-enc-dec LANGUAGES CXX)

find_package(Threads REQUIRED)
find_package(OpenMP REQUIRED)

set(USE_FFTW3 ON)
set(USE_RANDEN OFF)
add_subdirectory(TFHEpp)

set(CMAKE_C_FLAGS "")
set(CMAKE_C_FLAGS_DEBUG "")
set(CMAKE_C_FLAGS_RELEASE "")
set(CMAKE_CXX_FLAGS "")
set(CMAKE_CXX_FLAGS_DEBUG "")
set(CMAKE_CXX_FLAGS_RELEASE "")

set(CMAKE_C_FLAGS "")
set(CMAKE_CXX_FLAGS "-Wall -Wextra -pedantic -Wno-sign-compare -O3 -march=native -g3")

add_executable(trgsw-enc-dec main.cpp proc.cpp)
target_compile_options(trgsw-enc-dec PUBLIC -Wall -Wextra -pedantic -Wno-sign-compare -O3 -march=native -g3)
target_link_libraries(trgsw-enc-dec tfhe++ Threads::Threads OpenMP::OpenMP_CXX)
