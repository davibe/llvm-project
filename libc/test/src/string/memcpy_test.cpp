//===-- Unittests for memcpy ----------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/__support/CPP/span.h"
#include "src/string/memcpy.h"
#include "utils/UnitTest/Test.h"

using __llvm_libc::cpp::array;
using __llvm_libc::cpp::span;
using Data = array<char, 2048>;

static const span<const char> k_numbers("0123456789", 10);
static const span<const char> k_deadcode("DEADC0DE", 8);

// Returns a Data object filled with a repetition of `filler`.
Data get_data(span<const char> filler) {
  Data out;
  for (size_t i = 0; i < out.size(); ++i)
    out[i] = filler[i % filler.size()];
  return out;
}

TEST(LlvmLibcMemcpyTest, Thorough) {
  const Data groundtruth = get_data(k_numbers);
  const Data dirty = get_data(k_deadcode);
  for (size_t count = 0; count < 1024; ++count) {
    for (size_t align = 0; align < 64; ++align) {
      auto buffer = dirty;
      const char *const src = groundtruth.data();
      void *const dst = &buffer[align];
      void *const ret = __llvm_libc::memcpy(dst, src, count);
      // Return value is `dst`.
      ASSERT_EQ(ret, dst);
      // Everything before copy is untouched.
      for (size_t i = 0; i < align; ++i)
        ASSERT_EQ(buffer[i], dirty[i]);
      // Everything in between is copied.
      for (size_t i = 0; i < count; ++i)
        ASSERT_EQ(buffer[align + i], groundtruth[i]);
      // Everything after copy is untouched.
      for (size_t i = align + count; i < dirty.size(); ++i)
        ASSERT_EQ(buffer[i], dirty[i]);
    }
  }
}

// FIXME: Add tests with reads and writes on the boundary of a read/write
// protected page to check we're not reading nor writing prior/past the allowed
// regions.
