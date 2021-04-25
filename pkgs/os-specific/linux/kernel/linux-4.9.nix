{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.266";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0qzigcslfp714vaswwlw93xj0h2f8laikppw6krrhfnh5wwrp5dr";
  };
} // (args.argsOverride or {}))
