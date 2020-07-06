{ stdenv, lib, fetchFromGitHub, fetchurl, gnu-efi }:

stdenv.mkDerivation rec {
  pname = "apple_set_os";
  version = "1";
  src = fetchFromGitHub {
    owner = "0xbb";
    repo = "apple_set_os.efi";
    rev = "v${version}";
    sha256 = "1lfpvyfw0vlxbdnz445iyyy8fcfci3hkvlzid9cdcjy5jz8b56i1";
  };
  meta = with lib; {
    descrption = "Tiny EFI program for unlocking the Intel IGD on the MacBookPro11,3 (and others) for Linux and Windows";
    homepage = "https://github.com/0xbb/apple_set_os.efi";
    license = licenses.mit;
  };

  # build
  buildInputs = [ gnu-efi ];
  buildPhase = "make";

  # fix header lookups
  NIX_CFLAGS_COMPILE = "-I ${gnu-efi}/include/efi -I ${gnu-efi}/include/efi/x86_64";

  # fix header includes
  patches = [
    (
      fetchurl {
        name = "fix-build-with-gnu-efi-3.0.4.patch";
        url = "https://github.com/0xbb/apple_set_os.efi/commit/792cd73156aea520533f389045c72db5e244252b.patch";
        sha256 = "10znv7dl1fg63r8fl8rjbvfq69ya07cy6fzjy3ycdjfdf9gmbgp0";
      }
    )
  ];

  # fix lib dir paths
  GNU_EFI_LIB = "${gnu-efi}/lib";
  postPatch = ''
    sed 's,/usr/lib,$(GNU_EFI_LIB),' Makefile -i
  '';

  # install
  installPhase = "mkdir $out && cp apple_set_os.efi $out";
}
