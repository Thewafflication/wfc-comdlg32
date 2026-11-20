# REQ-0001 — The library DLL exports, versions and registers

**Content type:** Project requirement

**Status:** Proposed

**Source:** Distribution of the WFC libraries (WFC planning MP-0010); the
shared DLL contract of the WFC control libraries. Replaces part of the former
REQ-0304 (see `docs/id-map.md`).

## Scope

`wfccomdlg32.dll`, built with `WFC_COMDLG32_SHARED=ON`, on Windows. The static
library has no registration.

## Requirement

1. `wfccomdlg32.dll` shall export `DllGetClassObject`, `DllCanUnloadNow`,
   `DllRegisterServer` and `DllUnregisterServer`.
2. The version resource of the DLL shall carry the version of `VERSION` and
   the target of `TARGET`.
3. `DllRegisterServer` shall register the class `WFC.MSComDlg.CommonDialog`
   (class id `{CF6A2C7A-4FCB-5C54-9568-046A730724E8}`) in the registry of the
   current user when `WFC_REGISTER_SCOPE=user`; with
   `WFC_REGISTER_MICROSOFT_IDS=1` it shall also register the Microsoft ProgID
   `MSComDlg.CommonDialog.1` and class id
   `{F9043C85-F6F2-101A-A3C9-08002B2F49FB}`, and `DllUnregisterServer` shall
   remove everything it wrote and restore what was there before.
4. The class factory of `WFC.MSComDlg.CommonDialog` shall create an `IDispatch`
   control that keeps a value assigned to the property `CancelError`, accepts
   the method `ShowColor`, refuses aggregation (`CLASS_E_NOAGGREGATION`), does
   not know an invented member name, and lets `DllCanUnloadNow` return `S_OK`
   after its release.

## Rationale

A program that loads the library at run time, or registers it with
`regsvr32`, depends on these entry points and on a clean registration.

## Verification

**Method:** Test

**References:** `TC-0001`

## Relationships

- **Derived from:** WFC library distribution (MP-0010).
- **Depends on:** None.
- **Conflicts with:** None.

## Tailoring

None.

## Implementation Record

`src/wfccomdlg32.def`, `include/wfc/ocx/registration.hpp` and
`include/wfc/ocx/class_factory.hpp`. The class id and ProgID of Microsoft were
written from memory and are not yet checked against a Microsoft installation
(`COMPATIBILITY.md`).
