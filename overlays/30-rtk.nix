_self: super:
let
  version = "0.30.0";
  pname = "rtk";

  sources = {
    aarch64-darwin = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-aarch64-apple-darwin.tar.gz";
      sha256 = "16b4c3vc1kcvkjl1dkn9k885k7zvr7i2by3h44ig4jszsv34fyhc";
    };
    x86_64-darwin = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-x86_64-apple-darwin.tar.gz";
      sha256 = "188xk6m4ib6kjrf0dxjkag7v40yrnrvnyjky9w7qryx6zfry4r6q";
    };
    aarch64-linux = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-aarch64-unknown-linux-gnu.tar.gz";
      sha256 = "1jkgnnwymydzxg77dy2d187ak2bjwrc4g0bg62v819x8apahjpdl";
    };
    x86_64-linux = {
      url = "https://github.com/rtk-ai/rtk/releases/download/v${version}/rtk-x86_64-unknown-linux-musl.tar.gz";
      sha256 = "1vpwl9m476zgfrrnicnbs8wipvfcm6hy4j4kgsylh69bhi0g7jab";
    };
  };

  src = super.fetchurl {
    inherit (sources.${super.stdenv.hostPlatform.system}) url sha256;
  };

  isLinuxGnu = super.stdenv.hostPlatform.system == "aarch64-linux";
in
{
  rtk = super.stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = super.lib.optionals isLinuxGnu [
      super.autoPatchelfHook
    ];

    buildInputs = super.lib.optionals isLinuxGnu [
      super.stdenv.cc.cc.lib
    ];

    sourceRoot = ".";

    phases = [ "unpackPhase" "installPhase" ] ++
      super.lib.optionals isLinuxGnu [ "fixupPhase" ];

    unpackPhase = ''
      tar xzf $src
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp rtk $out/bin/rtk
      chmod +x $out/bin/rtk
    '';

    meta = with super.lib; {
      homepage = "https://github.com/rtk-ai/rtk";
      description = "CLI proxy that reduces LLM token consumption by filtering/compressing command outputs";
      license = licenses.mit;
      platforms = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
    };
  };
}
