proj=$1

mkdir $proj
cd $proj

mkdir src

echo "cmake_minimum_required(VERSION 3.21)

set(CMAKE_GENERATOR Ninja)
set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 23)

if(WIN32)
  set(CMAKE_C_COMPILER gcc)
  set(CMAKE_CXX_COMPILER g++)
else()
  set(CMAKE_C_COMPILER clang)
  set(CMAKE_CXX_COMPILER clang++)
endif()

set(CMAKE_BUILD_TYPE Debug)
project($proj)

add_executable(main src/main.cc)

add_custom_target(format ALL COMMAND clang-format -i -style=google \${CMAKE_SOURCE_DIR}/src/*.cc)" >CMakeLists.txt

echo '#include <algorithm>
#include <format>
#include <functional>
#include <iostream>
#include <utility>
#include <vector>

using namespace std;

void quicksort(vector<int> &nums, const int left, const int right) {
  if (left >= right) {
    return;
  }

  function<int()> partition = [&]() -> int {
    auto l = left, r = right, pivot = left;
    while (l < r) {
      while (l < r && nums[r] >= nums[pivot]) {
        r--;
      }
      while (l < r && nums[l] <= nums[pivot]) {
        l++;
      }
      swap(nums[l], nums[r]);
    }
    swap(nums[pivot], nums[l]);
    return l;
  };

  auto divider = partition();
  quicksort(nums, left, divider - 1);
  quicksort(nums, divider + 1, right);
}

int main() {
  auto nums = vector<int>{3, 4, 1, 5, 2};
  quicksort(nums, 0, nums.size() - 1);
  for_each(nums.begin(), nums.end(),
           [](const auto &item) { cout << format("{} ", item); });
}' >src/main.cc

cmake -S ./ -B ./build
cmake --build ./build
./build/main
