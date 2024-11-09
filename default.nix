{
  lib,
  stdenv,
  cmake,
  boost,
  glog,
  leveldb,
  marisa,
  opencc,
  yaml-cpp,
  gtest,
  capnproto,
  pkg-config,
  plugins ? [ ],
}:

let
  copySinglePlugin = plug: "cp -r ${plug} plugins/${plug.name}";
  copyPlugins = ''
    mkdir -p plugins
    ${lib.concatMapStringsSep "\n" copySinglePlugin plugins}
    chmod +w -R plugins/*
  '';
in
stdenv.mkDerivation {
  pname = "librime";
  version = "1.11.2";

  src = ./.;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    glog
    leveldb
    marisa
    opencc
    yaml-cpp
    gtest
    capnproto
  ] ++ plugins; # for propagated build inputs

  preConfigure = copyPlugins;

  meta = with lib; {
    homepage = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
