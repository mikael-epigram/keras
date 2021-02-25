#!/bin/bash
# Copyright 2020 Google Inc. All Rights Reserved.
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

set -e
set -x

cd "${KOKORO_ROOT}/"

# Use python 3.6 since some python PIP package dependency are released at 3.6, eg numpy.
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1

PYTHON_BINARY="/usr/bin/python3.6"

"${PYTHON_BINARY}" -m venv venv
source venv/bin/activate

# Check the python version
python --version
python3 --version

# numpy is needed by tensorflow as setup dependency.
pip install -U pip setuptools numpy

cd "src/github/keras"

bazel test --test_timeout 300,450,1200,3600 --test_output=errors --keep_going \
   --build_tests_only \
   --build_tag_filters="-no_oss" \
   --test_tag_filters="-no_oss" \
   -- //keras/...