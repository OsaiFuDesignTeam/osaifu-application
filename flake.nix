{
  description = "Flutter development for Linux, Android, and iOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: {
    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };
        # Match the pinned Flutter template's compileSdk/NDK and AGP requirements.
        buildToolsVersion = "36.0.0";
        ndkVersion = "28.2.13676358";
        android = pkgs.androidenv.composeAndroidPackages {
          platformVersions = [ "36" ];
          buildToolsVersions = [ buildToolsVersion ];
          includeNDK = true;
          ndkVersions = [ ndkVersion ];
          cmakeVersions = [ "3.22.1" ];
          toolsVersion = null;
        };
        androidHome = "${android.androidsdk}/libexec/android-sdk";
      in
      {
        default = pkgs.mkShellNoCC {
          packages = [
            pkgs.flutter
            pkgs.flutter.dart
            pkgs.git
            pkgs.jdk17
            android.androidsdk
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.cocoapods ];

          JAVA_HOME = pkgs.jdk17.home;
          ANDROID_HOME = androidHome;
          ANDROID_SDK_ROOT = androidHome;
          ANDROID_NDK_ROOT = "${androidHome}/ndk/${ndkVersion}";

          shellHook = ''
            export GRADLE_OPTS="''${GRADLE_OPTS:-} -Dorg.gradle.project.android.aapt2FromMavenOverride=${androidHome}/build-tools/${buildToolsVersion}/aapt2"
          '';
        };
      }
    );
  };
}
