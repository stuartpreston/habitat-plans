$pkg_name="chef-client-detox"
$pkg_origin="stuartpreston"
$pkg_version="14.11.21"
$pkg_upstream_url="https://github.com/chef/chef"
$pkg_revision="1"
$pkg_maintainer="Stuart Preston <stuart@chef.io>"
$pkg_license=@("Apache-2.0")
$pkg_bin_dirs=@("bin")
$pkg_build_deps=@("stuartpreston/chef-client/$pkg_version")

function Invoke-Build {
    # Start by making a shallow copy of the Ruby+Devkit installation, but exclude Habitat-specific files.
    $devkit_location = Get-HabPackagePath("chef-client")
    New-Item -Path $pkg_prefix -ItemType Directory -Force | Out-Null
    Copy-Item -Path $devkit_location/* -Destination $pkg_prefix -Recurse -Exclude @("config", "hooks", "default.toml", "IDENT", "MANIFEST", "PATH", "run", "RUNTIME_ENVIRONMENT", "RUNTIME_PATH", "SVC_GROUP", "SVC_USER", "TARGET") -Force

    # We need to start from the root of the repo (the location of the Gemspec.lock) and let's assume it's one directory higher than the plan.
    Push-Location $PLAN_CONTEXT/../

    # Build gems and anything else to be generated for the package here
    # and copy to $pkg_prefix if possible
    #
}

function Invoke-Install {
    # Install gems here
    #
    #
    
    # Explicitly scrub (non-recursive) any components that aren't required
    $paths_to_exclude = @("include", "msys64", "ridk_use", "unins000.*", "LICENSE.txt")
    foreach($excluded_path in $paths_to_exclude) {
        Get-ChildItem $pkg_prefix -Filter $excluded_path | Remove-Item -Recurse -Force
    }

    # Delete any files matching these names in all folders (recursive) - use with care!
    $paths_to_exclude_recursive = @("gem_make.out")
    foreach($excluded_path in $paths_to_exclude_recursive) {
        Get-ChildItem $pkg_prefix -Filter $excluded_path -Recurse | Remove-Item -Recurse -Force
    }

    # tidy up the bin folder to leave just the commands we need
    $bin_folder_files_to_keep = @("chef*", "knife*", "ohai*", "inspec*", "*.dll", "ruby*.exe", "gem*", "ruby_builtin_dlls", "*.manifest")
    Get-ChildItem $pkg_prefix/bin -Exclude $bin_folder_files_to_keep -Recurse | Remove-Item -Recurse -Force
}