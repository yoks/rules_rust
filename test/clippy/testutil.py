# Copyright 2020 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import os
import string


def runfile(path):
  """Resolves a runfile path."""
  return os.path.join(os.getenv("PYTHON_RUNFILES"), path)

def readlines(path):
  """Reads all the lines of a text runfile."""
  with open(runfile(path), "r") as f:
    return [line.strip() for line in f.readlines()]

def read_runfile(path):
  """Reads the content of a text runfile."""
  with open(runfile(path), "r") as f:
    return f.read()

def scratch_workspace(instance):
  """Scratch the test workspace."""

  print("RUNFILES: " + os.getenv("PYTHON_RUNFILES"))
  print("PWD: " + os.getcwd())
  instance.ScratchFile(
      "WORKSPACE",
      readlines("io_bazel_rules_rust/test/clippy/workspace/WORKSPACE.txt"))
  instance.ScratchFile(
      "BUILD",
      readlines("io_bazel_rules_rust/test/clippy/workspace/BUILD.txt"))
  instance.ScratchFile(
      "src/main.rs",
      readlines("io_bazel_rules_rust/test/clippy/workspace/src/main.rs"))
  instance.ScratchFile(
      "src/lib.rs",
      readlines("io_bazel_rules_rust/test/clippy/workspace/src/lib.rs"))
  instance.ScratchFile(
      "bad_src/main.rs",
      readlines("io_bazel_rules_rust/test/clippy/workspace/bad_src/main.rs"))
  instance.ScratchFile(
      "bad_src/lib.rs",
      readlines("io_bazel_rules_rust/test/clippy/workspace/bad_src/lib.rs"))
