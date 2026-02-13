#!/usr/bin/env python3
"""Add Phase 7 files (5 test files + 1 accessibility file) to project.pbxproj"""

import re

PBXPROJ = "/Users/elshanmagsudov/upful-ios/Upful.xcodeproj/project.pbxproj"

with open(PBXPROJ, "r") as f:
    content = f.read()

# ============================================================
# UUID scheme: GG prefix for Phase 7
# ============================================================
# AccessibilityModifiers.swift (main target)
ACC_FILE_REF  = "GG0000000100000100000001"
ACC_BUILD_REF = "GG0000000200000100000001"
ACC_GROUP     = "GG0000000300000100000001"  # Accessibility PBXGroup

# Test files (test target)
# PayoutViewModelTests.swift
T1_FILE_REF  = "GG0000000100000200000001"
T1_BUILD_REF = "GG0000000200000200000001"
# SubscriptionViewModelTests.swift
T2_FILE_REF  = "GG0000000100000200000002"
T2_BUILD_REF = "GG0000000200000200000002"
# StoreKitServiceTests.swift
T3_FILE_REF  = "GG0000000100000200000003"
T3_BUILD_REF = "GG0000000200000200000003"
# PayoutDTOsTests.swift
T4_FILE_REF  = "GG0000000100000200000004"
T4_BUILD_REF = "GG0000000200000200000004"
# PayoutEndpointsTests.swift
T5_FILE_REF  = "GG0000000100000200000005"
T5_BUILD_REF = "GG0000000200000200000005"

# ============================================================
# 1. Add PBXFileReference entries
# ============================================================
file_ref_entries = f"""		{ACC_FILE_REF} /* AccessibilityModifiers.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AccessibilityModifiers.swift; sourceTree = "<group>"; }};
		{T1_FILE_REF} /* PayoutViewModelTests.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PayoutViewModelTests.swift; sourceTree = "<group>"; }};
		{T2_FILE_REF} /* SubscriptionViewModelTests.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SubscriptionViewModelTests.swift; sourceTree = "<group>"; }};
		{T3_FILE_REF} /* StoreKitServiceTests.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = StoreKitServiceTests.swift; sourceTree = "<group>"; }};
		{T4_FILE_REF} /* PayoutDTOsTests.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PayoutDTOsTests.swift; sourceTree = "<group>"; }};
		{T5_FILE_REF} /* PayoutEndpointsTests.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PayoutEndpointsTests.swift; sourceTree = "<group>"; }};"""

# Insert before "/* End PBXFileReference section */"
content = content.replace(
    "/* End PBXFileReference section */",
    file_ref_entries + "\n/* End PBXFileReference section */"
)

# ============================================================
# 2. Add PBXBuildFile entries
# ============================================================
# AccessibilityModifiers goes in the MAIN target build phase
# Test files go in the TEST target build phase
build_file_entries = f"""		{ACC_BUILD_REF} /* AccessibilityModifiers.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ACC_FILE_REF} /* AccessibilityModifiers.swift */; }};
		{T1_BUILD_REF} /* PayoutViewModelTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {T1_FILE_REF} /* PayoutViewModelTests.swift */; }};
		{T2_BUILD_REF} /* SubscriptionViewModelTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {T2_FILE_REF} /* SubscriptionViewModelTests.swift */; }};
		{T3_BUILD_REF} /* StoreKitServiceTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {T3_FILE_REF} /* StoreKitServiceTests.swift */; }};
		{T4_BUILD_REF} /* PayoutDTOsTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {T4_FILE_REF} /* PayoutDTOsTests.swift */; }};
		{T5_BUILD_REF} /* PayoutEndpointsTests.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {T5_FILE_REF} /* PayoutEndpointsTests.swift */; }};"""

content = content.replace(
    "/* End PBXBuildFile section */",
    build_file_entries + "\n/* End PBXBuildFile section */"
)

# ============================================================
# 3. Add Accessibility PBXGroup and add it to Design group
# ============================================================
accessibility_group = f"""		{ACC_GROUP} /* Accessibility */ = {{
			isa = PBXGroup;
			children = (
				{ACC_FILE_REF} /* AccessibilityModifiers.swift */,
			);
			path = Accessibility;
			sourceTree = "<group>";
		}};"""

# Insert before "/* End PBXGroup section */"
content = content.replace(
    "/* End PBXGroup section */",
    accessibility_group + "\n/* End PBXGroup section */"
)

# Add Accessibility group to Design group (E87B1B3A2F3D605F004E6590)
# Design group currently has Components and Theme as children
content = content.replace(
    "E87B1B342F3D605F004E6590 /* Components */,\n\t\t\t\tE87B1B392F3D605F004E6590 /* Theme */,",
    f"E87B1B342F3D605F004E6590 /* Components */,\n\t\t\t\tE87B1B392F3D605F004E6590 /* Theme */,\n\t\t\t\t{ACC_GROUP} /* Accessibility */,"
)

# ============================================================
# 4. Add test files to UpfulTests PBXGroup (3D20FB3C22FB1F0A007836DD)
# ============================================================
# Current children end with Info.plist
content = content.replace(
    "3D20FB3F22FB1F0A007836DD /* Info.plist */,\n\t\t\t);\n\t\t\tpath = UpfulTests;",
    f"""3D20FB3F22FB1F0A007836DD /* Info.plist */,
				{T1_FILE_REF} /* PayoutViewModelTests.swift */,
				{T2_FILE_REF} /* SubscriptionViewModelTests.swift */,
				{T3_FILE_REF} /* StoreKitServiceTests.swift */,
				{T4_FILE_REF} /* PayoutDTOsTests.swift */,
				{T5_FILE_REF} /* PayoutEndpointsTests.swift */,
			);
			path = UpfulTests;"""
)

# ============================================================
# 5. Add AccessibilityModifiers to MAIN target PBXSourcesBuildPhase
# ============================================================
# The main target Sources phase: find the one that has all our Jyanik files
# We know it ends with "runOnlyForDeploymentPostprocessing = 0;" right after our files
# Let's find the Jyanik PBXSourcesBuildPhase - it's the one with FF prefix files

# Find the main PBXSourcesBuildPhase that contains FF0000 files (Phase 6)
# and add AccModifiers there
pattern_main_sources = re.compile(
    r'(FF0000000200000100000008 /\* PayoutDTOs\.swift in Sources \*/ = \{[^}]+\};)',
    re.DOTALL
)

# Simpler approach: Just search for the last FF entry in the Sources build phase
# and add after it
content = content.replace(
    f"FF0000000200000100000008 /* PayoutDTOs.swift in Sources */,",
    f"FF0000000200000100000008 /* PayoutDTOs.swift in Sources */,\n\t\t\t\t{ACC_BUILD_REF} /* AccessibilityModifiers.swift in Sources */,"
)

# ============================================================
# 6. Add test files to TEST target PBXSourcesBuildPhase (3D20FB3522FB1F0A007836DD)
# ============================================================
# The test Sources build phase currently has empty files = ()
test_sources_entries = f"""{T1_BUILD_REF} /* PayoutViewModelTests.swift in Sources */,
				{T2_BUILD_REF} /* SubscriptionViewModelTests.swift in Sources */,
				{T3_BUILD_REF} /* StoreKitServiceTests.swift in Sources */,
				{T4_BUILD_REF} /* PayoutDTOsTests.swift in Sources */,
				{T5_BUILD_REF} /* PayoutEndpointsTests.swift in Sources */,"""

# Replace the empty files = () in test Sources build phase
# The test Sources is: 3D20FB3522FB1F0A007836DD
content = content.replace(
    "3D20FB3522FB1F0A007836DD /* Sources */ = {\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t};",
    f"3D20FB3522FB1F0A007836DD /* Sources */ = {{\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n\t\t\t\t{test_sources_entries}\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t}};"
)

with open(PBXPROJ, "w") as f:
    f.write(content)

print("✅ Phase 7 files added to project.pbxproj:")
print("  - AccessibilityModifiers.swift → Jyanik/Design/Accessibility/ (main target)")
print("  - PayoutViewModelTests.swift → UpfulTests/ (test target)")
print("  - SubscriptionViewModelTests.swift → UpfulTests/ (test target)")
print("  - StoreKitServiceTests.swift → UpfulTests/ (test target)")
print("  - PayoutDTOsTests.swift → UpfulTests/ (test target)")
print("  - PayoutEndpointsTests.swift → UpfulTests/ (test target)")
