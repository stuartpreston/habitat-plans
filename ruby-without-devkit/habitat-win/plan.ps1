$pkg_name="ruby-without-devkit"
$pkg_origin="stuartpreston"
$pkg_version="2.6.3"
$pkg_revision="1"
$pkg_maintainer="Stuart Preston <stuart@chef.io>"
$pkg_license=@("Apache-2.0")
$pkg_source="https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-${pkg_version}-${pkg_revision}/rubyinstaller-${pkg_version}-${pkg_revision}-x64.exe"
$pkg_shasum="8223b330ca7d100c7f07e881985299768a1818cb8572a477910c6c13bea55947"
$pkg_bin_dirs=@("bin")

function Invoke-Unpack {
   Start-Process "$HAB_CACHE_SRC_PATH/$pkg_filename" -Wait -ArgumentList "/SP- /NORESTART /VERYSILENT /SUPPRESSMSGBOXES /NOPATH /DIR=$HAB_CACHE_SRC_PATH/$pkg_dirname"
}

function Invoke-Install {
   # Copy files to the packaging location
   Copy-Item "$HAB_CACHE_SRC_PATH/$pkg_dirname/*" "$pkg_prefix" -Recurse -Force

   # Remove original installer from system state
   Start-Process "$HAB_CACHE_SRC_PATH/$pkg_dirname/unins000.exe" -Wait -ArgumentList "/SILENT /NORESTART"
}
