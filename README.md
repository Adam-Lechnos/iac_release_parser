# iac_release_parser
A tool used for deciding a devops code release version based on supplied semantic version value within a sourced in repo json file

#### Intended Audience
* Devops

#### Pre-requisited
* Jenkins infrastructure which allows for selecting Devops code release upon build
* A soure repo which contains a supplied [iac.json](#iacjson) file with a specified [semantic version](https://semver.org/)
* [NPM package manager](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) and [NPM semver](https://www.npmjs.com/package/semver) within the Jenkins Main host
* `auth.cfg` with a GitHub access token accessbile to the GitHub organization/owner

#### iac.json
To be supplied at the root within source repos should the developer wished to select a Devops release upon deploy. The Jenkins infrastructure should first be able to accomodate Devops releases.
* The json structure containing one key/value with key `devops_release`, and value being the semantic version
* i.e., `devops_release: *.*.*` for the latest version, or omit this file
* i.e., `devops_release: 1.*.*` for the latest major release 1 version.

**Example**
```
{
	"devops_release": "*.*.*"
}
```

#### Usage
Call the `iac_parser.sh` within an active choice parameter dropdown in Jenkins, which upon repo selection as one of the position paramters, will return the semantic version decision against a list of available versions against the designated devops repo. The dropdown will provide the semantic version decision with no available options if the `iac.json` file is present. If this file is omiited, the dropdown will default to the latest version with a list of all available devops releases.
* Create an `auth.cfg` file with a variable `githubTokenGUI` containing the GitHub access token.
  *  This file should be specified within the `.gitignore` file to prevent repo accessbility.
*  An active choice parameter which supplied variable substitution for position parameters as follows:
  * Parameter 1 --> `repoName` - the selected repo within a seperate dropdown
  * Parameter 2 --> `repoRelease` - the release of the selected repo within a seperate dropdown
  * Parameter 3 --> `isGui` - `Yes`
    * should always be `Yes` to prevent a non-listed output 

#### Example
* The latest major release 1 of the Devops repo, as supplied by the Foobar developer repo v1.2.3
  * i.e., Foobar v1.2.3 Yes 
