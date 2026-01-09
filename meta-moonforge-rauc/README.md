# meta-moonforge-rauc

This layer adds RAUC support to manage OS updates.

## What it does

* Provides a common recipes to build RAUC bundles.
* Provides demo certificates to make it easier to sign bundles and test these locally.
* Extends the base image with recipes for setting up RAUC and its dependencies.
* Extends the base image with distro and local configurations to build images.

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-rauc.yml
```

See [meta-moonforge-rauc](../kas/include/layer/meta-moonforge-rauc.yml).

Note that, to build images with this layer, additional layers are requires to provide the specific components to enable the target board.

## Examples

* See [moonforge-image-full-qemux86-64](../kas/examples/moonforge-image-full-qemux86-64.yml).

## Signing bundles

RAUC signs bundles with an SSL certificate. The default recipe will use the
certificates included in the Git repository. If you want to use your own
certificates, you will need to generate them using the `openssl-ca.sh`
script provided by the meta-rauc layer:

```sh
$ cd meta-rauc/scripts
$ ./openssl-ca.sh
```

The script will create an `openssl-ca` directory where you'll find these
files:

- `openssl-ca/dev/private/development-1.key.pem`: the private key file
- `openssl-ca/dev/development-1.cert.pem`: the public certificate file
- `openssl-ca/dev/ca.cert.pem`: the public keyring file

You should copy those files in a separate location, a then export the
following environment variables:

```sh
$ export RAUC_KEY_FILE=/path/to/development-1.key.pem
$ export RAUC_CERT_FILE=/path/to/development-1.cert.pem
$ export RAUC_KEYRING_FILE=/path/to/ca.cert.pem
```

