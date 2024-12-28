{ 
  stdenv, 
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "avrdis"; 
  version = "1.0";

  src = fetchFromGitHub { 
    owner = "imrehorvath";
    repo = "avrdis";
    rev = "2ef2dc1aebb08190c9d66cfad46917a3638d4782";
    sha256 = "sha256-wUg5nxcYWe5JI1Ahq6suX7G4E30zpkbj/wBsBde7tUQ=";
  };

  installPhase = ''
    make DESTDIR=$out PREFIX="" install
  '';
}
