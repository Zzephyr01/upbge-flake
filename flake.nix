{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs";
    nnn.url = "github:nixos/nixpkgs";
    # libpipewire = nnn.libpipewire;
  };
  
  outputs = { self, nnn }:
    let my-pkgs = nnn.legacyPackages.x86_64-linux;
        lib = my-pkgs.lib;
        # stdenv = my-pkgs.stdenv;
        stdenv = my-pkgs.clangStdenv;
        
    in{
      foo = "bar";
      cool = 23;
      packages.x86_64-linux.my-upbge = my-pkgs.blender.overrideAttrs(final: prev: {
        version = "4.3.2";

        srcs = [
          (my-pkgs.fetchgit {
            name = "source";
            # url = "https://projects.blender.org/blender/blender.git";
            url = "https://github.com/UPBGE/upbge.git";
            # rev = "v${final.version}";
            fetchLFS = true;
            hash = "sha256-OBd2nuguLjijaKucoVw1bTPiPHyku7U3v4ZGHOyFYRs=";
          })
          (my-pkgs.fetchgit {
            name = "assets";
            url = "https://projects.blender.org/blender/blender-assets.git";
            rev = "v${final.version}";
            fetchLFS = true;
            hash = "sha256-B/UibETNBEUAO1pLCY6wR/Mmdk2o9YyNs6z6pV8dBJI=";
          })
        ];

        postUnpack = ''
              chmod -R u+w *
              rm -r assets/working
              rm -r source/release/datafiles/assets
              mv assets --target-directory source/release/datafiles/
              '';


        # откл. патчи 
        patches = [];
          #   ./draco.patch
          #   (my-pkgs.fetchpatch2 {
          #     url = "https://gitlab.archlinux.org/archlinux/packaging/packages/blender/-/raw/4b6214600e11851d7793256e2f6846a594e6f223/ffmpeg-7-1.patch";
          #     hash = "sha256-YXXqP/+79y3f41n3cJ3A1RBzgdoYqfKZD/REqmWYdgQ=";
          #   })
          #   (my-pkgs.fetchpatch2 {
          #     url = "https://gitlab.archlinux.org/archlinux/packaging/packages/blender/-/raw/4b6214600e11851d7793256e2f6846a594e6f223/ffmpeg-7-2.patch";
          #     hash = "sha256-mF6IA/dbHdNEkBN5XXCRcLIZ/8kXoirNwq7RDuLRAjw=";
          #   })
          # ] ++ lib.optional stdenv.hostPlatform.isDarwin ./darwin.patch;

        buildInputs = prev.buildInputs ++ [my-pkgs.pipewire.dev];

        cmakeFlags = prev.cmakeFlags ++ ["-DWITH_PLAYER=OFF"]; # окл. билд плеера
          
        
      });
      
      devShell.x86_64-linux =
        my-pkgs.mkShell {
          buildInputs = [ self.packages.x86_64-linux.my-upbge ];
        };
  };
}
