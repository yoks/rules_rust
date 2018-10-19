# Copyright 2018 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

def _parse_version(version_string):
  """
  Parse the version from a string
  The format handled is "<major>.<minor>.<patch>-<date> <commit>"
  Args:
    version_string: the version string to parse
  Returns:
    A 3-tuple of numbers: (<major>, <minor>, <patch>)
  """
  # Remove commit from version.
  version = version_string.split(" ", 1)[0]

  # Split into (release, date) parts and only return the release
  # as a tuple of integers.
  parts = version.split("-", 1)
  # Handle format x.x.xrcx
  parts = parts[0].split("rc", 1)

  # Turn "release" into a tuple of numbers
  version_tuple = ()
  for number in parts[0].split("."):
    version_tuple += (int(number),)
  return version_tuple


def _check_version(current_version, minimum_version):
  """
  Verify that a version string greater or equal to a minimum version string.
  The format handled for the version strings is "<major>.<minor>.<patch>-<date> <commit>"
  Args:
    current_version: a string indicating the version to check
    minimum_version: a string indicating the minimum version
  Returns:
    True if current_version is greater or equal to the minimum_version, False otherwise
  """
  return _parse_version(current_version) >= _parse_version(minimum_version)


# Check that a specific bazel version is being used.
# Args: minimum_bazel_version in the form "<major>.<minor>.<patch>"
def check_bazel_version(minimum_bazel_version, message = ""):
  """
  Verify the users Bazel version is at least the given one.
  This should be called from the `WORKSPACE` file so that the build fails as
  early as possible. For example:
  ```
  # in WORKSPACE:
  load("@build_bazel_rules_nodejs//:defs.bzl", "check_bazel_version")
  check_bazel_version("0.11.0")
  ```
  Args:
    minimum_bazel_version: a string indicating the minimum version
    message: optional string to print to your users, could be used to help them update
  """
  if "bazel_version" not in dir(native):
    fail("\nCurrent Bazel version is lower than 0.2.1, expected at least %s\n" %
         minimum_bazel_version)
  elif not native.bazel_version:
    print("\nCurrent Bazel is not a release version, cannot check for " +
          "compatibility.")
    print("Make sure that you are running at least Bazel %s.\n" % minimum_bazel_version)
  else:
    if not _check_version(native.bazel_version, minimum_bazel_version):
      fail("\nCurrent Bazel version is {}, expected at least {}\n{}".format(
          native.bazel_version, minimum_bazel_version, message))

