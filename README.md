# README

## Prerequisites

- Install Git. See: [Install Git](https://github.com/git-guides/install-git#install-git)
- Install Github CLI. See: [Installing Github CLI](https://github.com/cli/cli#installation)
- Install Git-Tfs. See: [Get git-tfs](https://github.com/git-tfs/git-tfs#get-git-tfs)
    - You need **at least** .NET 4.6.2 and the 2012 or 2013 version of Team Explorer installed (or Visual Studio) depending on the version of TFS you want to target.
## Before You Get Started
- Clone this repo and initialize the submodules
```bash
git clone https://github.com/martins-vds/tfvc-git-migration-scripts.git
git submodule update --init
```
- If this repo is already cloned locally, pull the latest changes:
```bash
git pull --recurse-submodules
```

## Execution Sequence
1. Initialize the local git repo which will be the target of the TFVC migration. Example:
```posh
.\Init-LocalRepo.ps1 -GitRepoDirectory "c:\path\to\local\git\folder" -TfsUrl "https://contoso.com/tfs/defaultcollection" -TfsRepoPath "$/Contoso/Trunk" -IgnoreFile "c:\path\to\gitignore"
```
2. Initialize the Github repo which will host the migrated code. Example
```posh
.\Init-GithubRepo.ps1 -GitRepoDirectory "c:\path\to\local\git\folder" -Token "authTokenGoesHere" -Name "NameOfRepoGoesHere" -Description "DescriptionOfRepoGoesHere" -Team "TeamAssignedToRepo" -Organization "OrgNameGoesHere"
```

- *The "Team" argument is **optional***

> To generate an auth token, see [Creating a personal access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token)
> The auth token requires the 2 scopes: "repo" and "read:org" (under "admin:org")

3. Pull from TFS. Example:
```posh
.\Pull-Tfs.ps1 -Changeset 1234 -GitRepoDirectory "c:\path\to\local\git\folder"
```
> :warning::warning::warning:
> MAKE SURE THAT THE CODE BUILDS CORRECTLY BEFORE MOVING ON TO THE NEXT STEP
> :warning::warning::warning:
4. Initialize GitVersion. Example:
```posh
.\Init-GitVersion.ps1 -NextVersion 1.0.0 -GitRepoDirectory "c:\path\to\local\git\folder"
```
5. Push the local git repo to Github. Example:
```posh
.\Push-Github.ps1 -GitRepoDirectory "c:\path\to\local\git\folder"
```
6. Cleanup TFS related configs. Example:
```posh
.\Cleanup-TfsConfigs.ps1 -GitRepoDirectory "c:\path\to\local\git\folder"
```