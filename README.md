# iac_release_parser
A tool used for deciding a devops code release version based on supplied semantic version value within a sourced in repo json file

#### Intended Audience
* Devops

#### Pre-requisited
* Jenkins infrastructure which allows for selecting Devops code release upon build
* A soure repo which contains a supplied [iac.json](#iacjson) file with a specified [semantic version](https://semver.org/)
* [NPM package manager](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) and [NPM semver](https://www.npmjs.com/package/semver) within the Jenkins Main host

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
Call the `iac_parser.sh` within an active choice paramter dropdown in Jenkins, which upon repo selection as one of the position paramters, will return the semantic version decision against a list of available versions against the designated devops repo.
