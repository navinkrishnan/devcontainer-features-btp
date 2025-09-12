
# SAP BTP CAP Dev Stack (btp-cap-dev-stack)

Installs tools for SAP BTP CAP app development and deployment

## Example Usage

```json
"features": {
    "ghcr.io/navinkrishnan/devcontainer-features-btp/btp-cap-dev-stack:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| cds-dk | SAP CAP cds-dk version (or 'none') | string | latest |
| cf | Cloud Foundry CLI version (or 'none') | string | latest |
| pack | Buildpacks Pack CLI version (or 'none') | string | latest |
| mbt | SAP Cloud MTA Build Tool (mbt) version (or 'none') | string | latest |
| kubectl | Kubernetes CLI (kubectl) version (or 'none') | string | latest |
| kubelogin | Kubernetes Login (kubelogin) version (or 'none') | string | latest |
| helm | Helm version (or 'none') | string | latest |

## Customizations

### VS Code Extensions

- `mechatroner.rainbow-csv`
- `dbaeumer.vscode-eslint`
- `sapse.vscode-cds`
- `sapse.vsc-extension-odata-csdl-modeler`
- `sapse.vscode-wing-cds-editor-vsc`
- `saposs.xml-toolkit`
- `humao.rest-client`
- `SAPSE.sap-ux-fiori-tools-extension-pack`
- `vscjava.vscode-java-debug`
- `vscjava.vscode-java-pack`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
