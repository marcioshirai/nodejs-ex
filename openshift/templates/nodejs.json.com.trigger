{
  "kind": "Template",
  "apiVersion": "v1",
  "metadata": {
    "name": "${NAME}",
    "annotations": {
      "openshift.io/display-name": "Node.js",
      "description": "An example Node.js application with no database. For more information about using this template, including OpenShift considerations, see https://github.com/marcioshirai/nodejs-ex/blob/master/README.md.",
      "tags": "quickstart,nodejs",
      "iconClass": "icon-nodejs",
      "openshift.io/long-description": "This template defines resources needed to develop a NodeJS application, including a build configuration and application deployment configuration.  It does not include a database.",
      "openshift.io/provider-display-name": "Red Hat, Inc.",
      "openshift.io/documentation-url": "https://github.com/marcioshirai/nodejs-ex",
      "openshift.io/support-url": "https://access.redhat.com",
      "template.openshift.io/bindable": "false"
    }
  },
  "message": "The following service(s) have been created in your project: ${NAME}.\n\nFor more information about using this template, including OpenShift considerations, see https://github.com/marcioshirai/nodejs-ex/blob/master/README.md.",
  "labels": {
      "template": "${NAME}",
      "app": "${NAME}"
  },
  "objects": [
    {
      "kind": "Service",
      "apiVersion": "v1",
      "metadata": {
        "name": "${NAME}",
        "annotations": {
          "description": "Exposes and load balances the application pods"
        }
      },
      "spec": {
        "ports": [
          {
            "name": "web",
            "port": 8080,
            "targetPort": 8080
          }
        ],
        "selector": {
          "name": "${NAME}"
        }
      }
    },
    {
      "kind": "Route",
      "apiVersion": "v1",
      "metadata": {
        "name": "${NAME}"
      },
      "spec": {
        "host": "${APPLICATION_DOMAIN}",
        "to": {
          "kind": "Service",
          "name": "${NAME}"
        }
      }
    },
    {
      "kind": "ImageStream",
      "apiVersion": "v1",
      "metadata": {
        "name": "${NAME}",
        "annotations": {
          "description": "Keeps track of changes in the application image"
        }
      }
    }, 
    {
      "kind": "DeploymentConfig",
      "apiVersion": "v1",
      "metadata": {
        "name": "${NAME}",
        "annotations": {
          "description": "Defines how to deploy the application server",
          "template.alpha.openshift.io/wait-for-ready": "true"
        }
      },
      "spec": {
        "strategy": {
          "type": "Rolling"
        },
        "triggers": [
          {
            "type": "ImageChange",
            "imageChangeParams": {
              "automatic": true,
              "containerNames": [
                "${NAME}"
              ],
              "from": {
                "kind": "ImageStreamTag",
                "name": "${NAME}:latest"
              }
            }
          },
          {
            "type": "ConfigChange"
          }
        ],
        "replicas": 1,
        "selector": {
          "name": "${NAME}"
        },
        "template": {
          "metadata": {
            "name": "${NAME}",
            "labels": {
              "name": "${NAME}"
            }
          },
          "spec": {
            "containers": [
              {
                "name": "${NAME}",
                "image": " ",
                "ports": [
                  {
                    "containerPort": 8080
                  }
                ],
                "readinessProbe": {
                  "timeoutSeconds": 3,
                  "initialDelaySeconds": 3,
                  "httpGet": {
                    "path": "/",
                    "port": 8080
                  }
                },
                "livenessProbe": {
                    "timeoutSeconds": 3,
                    "initialDelaySeconds": 30,
                    "httpGet": {
                        "path": "/",
                        "port": 8080
                    }
                },
                "resources": {
                    "limits": {
                        "memory": "${MEMORY_LIMIT}"
                    }
                },
                "env": [
                ]
              }
            ]
          }
        }
      }
    }
  ],
  "parameters": [
    {
      "name": "NAME",
      "displayName": "Name",
      "description": "The name assigned to all of the frontend objects defined in this template.",
      "required": true,
      "value": "nodejs-example"
    },
    {
      "name": "NAMESPACE",
      "displayName": "Namespace",
      "description": "The OpenShift Namespace where the ImageStream resides.",
      "required": true,
      "value": "openshift"
    },
    {
      "name": "NODEJS_VERSION",
      "displayName": "Version of NodeJS Image",
      "description": "Version of NodeJS image to be used (6, 8, or latest).",
      "value": "8",
      "required": true
    },
    {
      "name": "MEMORY_LIMIT",
      "displayName": "Memory Limit",
      "description": "Maximum amount of memory the container can use.",
      "required": true,
      "value": "512Mi"
    },
    {
      "name": "SOURCE_REPOSITORY_URL",
      "displayName": "Git Repository URL",
      "description": "The URL of the repository with your application source code.",
      "required": true,
      "value": "https://github.com/marcioshirai/nodejs-ex.git"
    },
    {
      "name": "SOURCE_REPOSITORY_REF",
      "displayName": "Git Reference",
      "description": "Set this to a branch name, tag or other ref of your repository if you are not using the default branch."
    },
    {
      "name": "CONTEXT_DIR",
      "displayName": "Context Directory",
      "description": "Set this to the relative path to your project if it is not in the root of your repository."
    },
    {
      "name": "APPLICATION_DOMAIN",
      "displayName": "Application Hostname",
      "description": "The exposed hostname that will route to the Node.js service, if left blank a value will be defaulted.",
      "value": ""
    },
    {
      "name": "GITHUB_WEBHOOK_SECRET",
      "displayName": "GitHub Webhook Secret",
      "description": "Github trigger secret.  A difficult to guess string encoded as part of the webhook URL.  Not encrypted.",
      "generate": "expression",
      "from": "[a-zA-Z0-9]{40}"
    },
    {
      "name": "GENERIC_WEBHOOK_SECRET",
      "displayName": "Generic Webhook Secret",
      "description": "A secret string used to configure the Generic webhook.",
      "generate": "expression",
      "from": "[a-zA-Z0-9]{40}"
    },
    {
      "name": "NPM_MIRROR",
      "displayName": "Custom NPM Mirror URL",
      "description": "The custom NPM mirror URL",
      "value": ""
    }
  ]
}

