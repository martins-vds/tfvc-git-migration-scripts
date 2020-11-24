# README

## Tools Required

- Github CLI
- Git-Tfs

## Execution Sequence
1. Clone this repo and initialize the submodules
```bash
git clone https://github.com/martins-vds/tfvc-git-migration-scripts.git
git submodule update --init
```
- If this repo is already cloned locally, pull the latest changes:
```bash
git pull --recurse-submodules
```
2. Initialize the local git repo which will be the target of the TFVC migration
```posh
.\Init-LocalRepo.ps1
```
3. Initialize the Github repo which will host the migrated code
```posh
.\Init-GithubRepo.ps1
```
4. Pull from TFS
```posh
.\Pull-Tfs.ps1
```
> :warning::warning::warning: 
> Make sure that the code builds correctly before moving on to the next step 
> :warning::warning::warning:
5. Initialize GitVersion
```posh
.\Init-GitVersion.ps1
```
6. Push the local git repo to Github
```posh
.\Push-Github.ps1
```