#!/bin/bash
#
# USER ACTION REQUIRED: This is a scaffold file intended for the user to modify
#
# Pre-install script REQUIRED ONLY IF additional setup is required prior to
# operator install for this test path.
#
# For example, if PersistantVolumes (PVs) are required
#
set -o errexit
set -o nounset
set -o pipefail

preinstallDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
operator=ibm-spectrum-scale-csi-operator

# Verify pre-req environment
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }

# Optional - set tool repo and source library for creating/configuring namespace
# NOTE: toolrepositoryroot needed for setting Policy Security Policy
. $APP_TEST_LIBRARY_FUNCTIONS/createNamespace.sh
toolrepositoryroot=$APP_TEST_LIBRARY_FUNCTIONS/../../

#createNamespace ${CV_TEST_NAMESPACE}
setNamespace ${CV_TEST_USER} ${CV_TEST_NAMESPACE}

$APP_TEST_LIBRARY_FUNCTIONS/operatorDeployment.sh \
    --serviceaccount $CV_TEST_BUNDLE_DIR/operators/${operator}/deploy/service_account.yaml \
    --crd $CV_TEST_BUNDLE_DIR/operators/${operator}/deploy/crds/ibm-spectrum-scale-csi-operator-crd.yaml \
    --role $CV_TEST_BUNDLE_DIR/operators/${operator}/deploy/role.yaml \
    --rolebinding $CV_TEST_BUNDLE_DIR/operators/${operator}/deploy/role_binding.yaml \
    --operator $CV_TEST_BUNDLE_DIR/operators/${operator}/deploy/operator.yaml
    # --secretname FIXME \
    # --imagename FIXME

# Optional setup for hardcoded namespace(s) with specific Pod Security Policy
# NOTE: clean-up.sh need to contain matching removeNamespace
# removeNamespace testopr ibm-privileged-psp || true
# configureNamespace testopr ibm-privileged-psp
