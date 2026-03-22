_self: super: {
  rtk = super.rustPlatform.buildRustPackage {
    pname = "rtk";
    version = "0.31.0";

    src = super.fetchFromGitHub {
      owner = "rtk-ai";
      repo = "rtk";
      rev = "v0.31.0";
      hash = "sha256-p4OX3SSDGKlHVLIWhgKpcme449wOHbfWbc3mxlCkaMI=";
    };

    cargoHash = "sha256-37YHhccgPNUrlFh35CoQv2H+Y4e41ax0ZoIvrIC0o6I=";

    doCheck = false;

    meta = with super.lib; {
      description = "CLI proxy to minimize LLM token consumption";
      homepage = "https://github.com/rtk-ai/rtk";
      license = licenses.mit;
      mainProgram = "rtk";
    };
  };
}
