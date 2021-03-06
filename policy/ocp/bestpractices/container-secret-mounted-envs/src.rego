package ocp.bestpractices.container_secret_mounted_envs

import data.lib.konstraint
import data.lib.openshift

# @title Container secret not mounted as envs
#
# The content of Secret resources should be mounted into containers as volumes rather than passed in as environment variables.
# This is to prevent that the secret values appear in the command that was used to start the container, which may be inspected
# by individuals that shouldn't have access to the secret values.
# See: Configuration and secrets -> https://learnk8s.io/production-best-practices#application-development
#
# @kinds apps.openshift.io/DeploymentConfig apps/DaemonSet apps/Deployment apps/StatefulSet
violation[msg] {
  openshift.is_workload_kind

  container := openshift.containers[_]

  env := container.env[_]
  env.valueFrom.secretKeyRef
  obj := konstraint.object

  msg := konstraint.format(sprintf("%s/%s: container '%s' has a secret '%s' mounted as an environment variable. As secrets are not secret, its not good practice to mount as env vars.", [obj.kind, obj.metadata.name, container.name, env.valueFrom.secretKeyRef.name]))
}