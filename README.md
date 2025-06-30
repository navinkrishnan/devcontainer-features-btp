# btp-cap-dev-stack

An unofficial Visual Studio code [dev container](https://containers.dev/) feature with a collection of tools to support CAP application development in SAP BTP.

Installs the following command line utilities:

* [cds-dk](https://cap.cloud.sap/docs/releases/)
* [cf](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [kubelogin](https://github.com/Azure/kubelogin/releases)
* [Helm](https://github.com/helm/helm/releases)
* [Pack](https://buildpacks.io/docs/for-platform-operators/how-to/integrate-ci/pack/)


Auto-detects latest versions and installs needed dependencies.

## Usage

All the latest versions are installed by default. You can pin a specific version or specify `latest` or `none` if you wish to have the latest version or skip the installation of any specific cli. Please see below for an example:

```
"features": {
    "ghcr.io/navinkrishnan/devcontainer-features-btp/btp-cap-dev-stack:1": {
        "cds-dk": "latest",
        "kubectl": "latest",
        "helm": "none",
        "kubelogin": "0.0.22"
    }
}
```

## Contributors
<a href="https://github.com/navinkrishnan/devcontainer-features-btp/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=navinkrishnan/devcontainer-features-btp" />
</a>