{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs";
    nnn.url = "github:nixos/nixpkgs";

  };
  
  outputs = { self, nnn }:
    let my-pkgs = nnn.legacyPackages.x86_64-linux;
        
        #bash = my-pkgs.bash;
        # xorg = my-pkgs.xorg;
        
    in{ 
      foo = "bar";
      cool = 23;
      # packages.x86_64-linux.todel = import ./todel  {a = 23; inherit (my-pkgs) bash coreutils;}  ;#{inherit (my-pkgs) stdenv;};

      # overlays = [
      #   (fin: prev: 
      #     {
      #       # openvdb = my-pkgs.openvdb.overrideAttrs
      #       openvdb = prev.my-upbge.override
      #         (old:
      #           {
      #             src = my-pkgs.fetchFromGitHub 
      #             {
      #               owner = "AcademySoftwareFoundation";
      #               repo = "openvdb";
      #               # rev = "v${version}";
      #               sha256 = "";
      #             };
      #           }
      #         );
      #     }
      #   )];

      packages.x86_64-linux.my-upbge = import ./my-upbge my-pkgs;
      # packages.x86_64-linux.my-upbge = my-pkgs.callPackage ./my-upbge my-pkgs {};

      
      devShell.x86_64-linux =
        my-pkgs.mkShell {
          buildInputs = [ self.packages.x86_64-linux.my-upbge ];
        };
  };
}
