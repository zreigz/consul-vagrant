#!/bin/bash

# Copyright 2016 The Kubernetes Authors All rights reserved.
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

# exit on any error
set -e

ROLE=$1

source $(dirname "${BASH_SOURCE}")/util.sh

install_minimal_dependencies

install_docker


hostnamectl set-hostname '$(ROLE)'

curl -X PUT -d @hostname.json localhost:8500/v1/agent/service/register


docker run --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' -e 'CONSUL_ALLOW_PRIVILEGED_PORTS=' consul agent -server -bind=10.9.8.7 -retry-join=10.9.8.6;10.9.8.5 -bootstrap-expect=2 -dns-port=53 -enable-script-checks
