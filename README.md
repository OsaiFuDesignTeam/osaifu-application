# OsaiFu App

## Setup

1. Install [Nix](https://nixos.org/download/) with `nix-command` and `flakes` enabled.
2. On macOS, install Xcode from the App Store and Google Chrome.
   Open Xcode, accept its license, and install the required platform components.
   Select Xcode as the active developer directory:

   ```sh
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```

3. From the project root, enter the development environment and check the setup:

   ```sh
   nix develop
   flutter doctor -v
   ```
