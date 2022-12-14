// RUN: %clang_cc1 -triple aarch64-linux-gnu -target-feature +sve -verify %s

typedef __attribute__((aarch64_sve_pcs)) int invalid_typedef; // expected-warning {{'aarch64_sve_pcs' only applies to function types; type here is 'int'}}

void __attribute__((aarch64_sve_pcs(0))) foo0(void); // expected-error {{'aarch64_sve_pcs' attribute takes no arguments}}

void __attribute__((aarch64_sve_pcs, preserve_all)) foo1(void); // expected-error {{not compatible}}

void __attribute__((cdecl)) foo2(void);             // expected-note {{previous declaration is here}}
void __attribute__((aarch64_sve_pcs)) foo2(void) {} // expected-error {{function declared 'aarch64_sve_pcs' here was previously declared 'cdecl'}}

void foo3(void);                                    // expected-note {{previous declaration is here}}
void __attribute__((aarch64_sve_pcs)) foo3(void) {} // expected-error {{function declared 'aarch64_sve_pcs' here was previously declared without calling convention}}

typedef int (*fn_ty)(void);
typedef int __attribute__((aarch64_sve_pcs)) (*aasvepcs_fn_ty)(void);
void foo4(fn_ty ptr1, aasvepcs_fn_ty ptr2) {
  ptr1 = ptr2; // expected-error {{incompatible function pointer types}}
}
