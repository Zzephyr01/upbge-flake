{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs";
    nnn.url = "github:nixos/nixpkgs";

  };
  
  outputs = { self, nnn }:
    let my-pkgs = nnn.legacyPackages.x86_64-linux;
        # xorg = my-pkgs.xorg;
        
    in{ 
      foo = "bar";
      cool = 23;
      packages.x86_64-linux.todel = import ./todel;

      # packages.x86_64-linux.my-upbge = import ./my-upbge my-pkgs;
      packages.x86_64-linux.my-upbge = my-pkgs.callPackage ./my-upbge my-pkgs {};

      
      devShell.x86_64-linux =
        my-pkgs.mkShell {
          buildInputs = [ self.packages.x86_64-linux.my-upbge ];
        };
  };
}
