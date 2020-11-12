# PoC Scanner

Thank you for participating in our Proof of Concept of our Codebase Audit tool.

## How it works

The Bearer Scanner binary is building a JSON file for each repository with the following info:

- Metadata related to the repo (Git remote URL, last commit, ...)
- The list of detected domains
- The list of detected dependencies

The Scanner will go over all your files and look for patterns in your code that matches a domain. It will create a ZIP archive with all the JSON files generated. You will need to send this file back to us at Bearer, so that we can perform further search and resolutions on our side. We will then load the results into a dashboard, where you will be able to retrieve all the collected data plus the informations we collected on our side.

## How to use it

We provide a script that will download the binary to `~/.bearer/bearer-cli`

```console
$ curl "https://raw.githubusercontent.com/Bearer/scanner-poc/main/download.sh" | bash -s
Downloading to ~/.bearer/bearer-cli
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 20.8M  100 20.8M    0     0  20.4M      0  0:00:01  0:00:01 --:--:-- 20.4M
Please visit https://github.com/Bearer/scanner-poc/blob/main/README.md#how-to-use-it for the binary usage
```
**To update binary** simply run `./download.sh` script again. It will overwrite the existing `~/.bearer/bearer-cli` file and set the executable flags.

## Binary usage

In all cases the binary execution will generate the ZIP report in your working directory. You then can send this ZIP to Bearer.sh.

### You already have all the repositories locally.

Run the binary passing the list of repository folders

```console
$ ~/.bearer/bearer-cli local <path_to_source_code_root_folder_1> <path_to_source_code_root_folder_2>
$ ls
bearer-cli.zip
```

#### Paranoid mode

<details>
The following method is less practical to use and has more limitations;
However, it can help you build an isolated environment to run the scanner.

```console
$ docker run -it --rm \
	-w "$PWD" -v "$PWD:$PWD" \
	buildpack-deps sh -ec \
	'curl -sL "https://raw.githubusercontent.com/Bearer/scanner-poc/main/download.sh" | bash -s && ~/.bearer/bearer-cli local <path_to_source_code_root_folder_1> <path_to_source_code_root_folder_2>'
[...]
$ ls bearer_report_*.zip
bearer_report_2020-11-12-144452.zip
```

You can go even further by building an image that contains `git` and the binary, then run docker with the `--network=none` flag.

_disclaimer: this method is only shown as an example. Please use the standard version if you want to get support from the Bearer team._

It is very limited (only supporting forked repositories/projects).
</details>

### You don't have the repositories locally
We currently support the following remote git repositories:
* Github
* Self Hosted Github
* Gitlab
* Self Hosted Gitlab

The executable will download the list of repositories, run the scan and generate zip artifact. Examples on how to use binary for each case is shown below.


#### Github

```console
$ GITHUB_TOKEN=secret ~/.bearer/bearer-cli github mygithuborg/myrepo
```

You can generate your `repo` only GitHub API key here: https://github.com/settings/tokens

**Note** for ssh github access you might need to update your global git configuration in `~/.gitconfig` file by adding the following line:

```
[url "git@github.com:"]
	insteadOf = https://github.com
```

#### Self Hosted Github

Same as Option 2 except that you are have a Self Hosted version of GitHub

```console
$ GITHUB_TOKEN=secret ~/.bearer/bearer-cli github --base "https://my.github.instance" mygithuborg/myrepo
```

#### Gitlab

```console
$ GITLAB_TOKEN=secret ~/.bearer/bearer-cli gitlab mygitlaborg/myrepo
```

You will need a Gitlab API token with `read_api` scope.

### Self Hosted GitLab

```console
$ GITLAB_TOKEN=secret ~/.bearer/bearer-cli gitlab --base "https://my.gitlab.instance" mygitluborg/myrepo
```

### Upload the script back to Bearer

You just need to use our WeTransfer account. Go to https://bearer.wetransfer.com and upload it.

# Annexes

## `.gitignore`

The Scanner will ignore the files listed in your `.gitignore` if you have one.

## Metadata

<details>

```jsonc
{
  "name": "Repository Name",
  "git": {
    "url": "git@github.com:MyOrganization/repository-name.git",
    "branch": "master",
    "sha": "d050c0fd",
    "timestamp": "20201105T083124Z" // time of the last commit
  },
  "timestamp": "20201105T083124Z", // time when the file was generated
  "languages": [
    "Ruby" // Detected languages order of usage
  ]
  // ... domains
  // ... dependencies
}
```
</details>

## Detected Domains

<details>

```jsonc
{
  // ... metadata
  "domainReport": [
    {
      "filename": "app/javascripts/active_admin.js",
      "domains": [
        {
          "domain": "logo.clearbit.com",
          "lineNumber": 10
          "score": 0 // 0..100
        }
      ]
    },
    // ... dependencies
  ]
}
```
</details>

## Detected Dependencies

<details>

```jsonc
{
  // ... metadata
  // ... domains
  "dependencyReport": [
    {
      "filename": "package.json",
      "language": "Javascript",
      "dependencies": [
        {
          "name": "axios",
          "version": "^0.18.0",
          "lineNumber": 10
        },
        // ...
      ]
    },
    {
      "filename": "Gemfile.lock",
      "language": "Ruby",
      "dependencies": [
        {
          "name": "stripe",
          "version": "0.18.0",
          "lineNumber": 10
        },
        // ...
      ]
    }
  }
}
```
</details>

## Dependencies

<details>

### Ruby

- Gemfile.lock

### Python

- Pipfile.lock
- requirements.txt
- pyproject.toml
- pipdeptree.json
- poetry.lock

### Javascript

- package.json
- yarn.lock
- package-lock.json
- npm-shrinkwrap.json

### Java

- maven-dependencies.json
- gradle-dependencies.json
- build.gradle
- pom.xml
- ivy-report.xml

### Go

- go.sum

### PHP

- composer.lock
- composer.json

### C#

- project.json
- packages.config
- paket.dependencies
- packages.lock.json

</details>
