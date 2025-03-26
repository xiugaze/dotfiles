With Flakes, updating the system is straightforward. Simply execute the following commands in /etc/nixos or any other location where you keep the configuration:

```nix
# Update flake.lock
nix flake update

# Or replace only the specific input, such as home-manager:
nix flake update home-manager

# Apply the updates
sudo nixos-rebuild switch --flake .

# Or to update flake.lock & apply with one command (i.e. same as running "nix flake update" before)
sudo nixos-rebuild switch --recreate-lock-file --flake .
```

Occasionally, you may encounter a "sha256 mismatch" error when running nixos-rebuild switch. This error can be resolved by updating flake.lock using nix flake update.


## Go server project

Right now, we're explicitly tracking the main branch.
Flakes are supposed to be locked for reproducibility. To update, 
we have to run `nix flake update go-test-server` for that specific input
or run `nix flake update` for all inputs before rebuilding.

## home-manager
```
home-manager switch --flake .#user@host
```





