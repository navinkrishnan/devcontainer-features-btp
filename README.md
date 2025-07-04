# BTP Dev Container Features (devcontainer-features-btp)

An unofficial Visual Studio code [dev container](https://containers.dev/) feature with a collection of tools to accelerate the CAP (Cloud Application Programming Model) application development in SAP BTP.

Installs the following command line utilities:

* [cds-dk](https://cap.cloud.sap/docs/releases/)
* [cf](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [kubelogin](https://github.com/Azure/kubelogin/releases)
* [Helm](https://github.com/helm/helm/releases)
* [Pack](https://buildpacks.io/docs/for-platform-operators/how-to/integrate-ci/pack/)

Auto-detects latest versions and installs needed dependencies.

Installs the recommended vscode extensions

* mechatroner.rainbow-csv
* dbaeumer.vscode-eslint
* sapse.vscode-cds
* sapse.vsc-extension-odata-csdl-modeler
* sapse.vscode-wing-cds-editor-vsc
* saposs.xml-toolkit
* humao.rest-client
* SAPSE.sap-ux-fiori-tools-extension-pack
* vscjava.vscode-java-debug"
* vscjava.vscode-java-pack
## Available Features

| Feature ID | Description |
|------------|-------------|
| [`cds-dk`](./src/cds-dk) | Installs the [SAP CAP cds-dk CLI](https://cap.cloud.sap/docs/get-started/). |
| [`cf`](./src/cf) | Installs the latest [Cloud Foundry CLI](https://docs.cloudfoundry.org/cf-cli/) (v8). |
| [`pack`](./src/pack) | Installs the [Buildpacks Pack CLI](https://buildpacks.io/docs/tools/pack/). |
| [`mbt`](./src/mbt) | Installs the [Cloud MTA Build tool (mbt)](https://sap.github.io/cloud-mta-build-tool/). |

| [`btp-cap-dev-stack`](./src/btp-cap-dev-stack) | Installs all of the above tools with version overrides. Use this for a full setup. |

## Usage

All the latest versions are installed by default. You can pin a specific version or specify `latest` or `none` if you wish to have the latest version or skip the installation of any specific cli. Please see below for an example:

### Full Stack (btp-cap-dev-stack)

```json
"features": {
    "ghcr.io/navinkrishnan/devcontainer-features-btp/btp-cap-dev-stack:1": {
        "cds-dk": "latest",
        "kubectl": "latest",
        "helm": "none",
        "kubelogin": "0.0.22"
    }
}
```

### Use Individual Features

```json
"features": {
  "ghcr.io/navinkrishnan/devcontainer-features-btp/mbt:1": {},
  "ghcr.io/navinkrishnan/devcontainer-features-btp/pack:1": {},
  "ghcr.io/navinkrishnan/devcontainer-features-btp/cf:1": {},
  "ghcr.io/navinkrishnan/devcontainer-features-btp/cds-dk:1": {
    "version": "latest"
  }
}
```

## Contributors
<a href="https://github.com/navinkrishnan/devcontainer-features-btp/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=navinkrishnan/devcontainer-features-btp" />
</a>