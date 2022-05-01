# iac_release_parser
A tool used for deciding a devops code release version based on supplied semantic version value within a sourced in repo json file

#### Intended Audience
* Devops

#### Pre-requisited
* Jenkins infrastructure which allows for selecting Devops code release upon build
* A soure repo which contains a supplied iac.json file with a specified [semantic version](https://semver.org/)
* [NPM package manager](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) and [NPM semver](https://www.npmjs.com/package/semver) within the Jenkins Main host

#### iac.json
To be supplied at the root within source repos should the developer wished to select a Devops release upon deploy. The Jenkins infrastructure should first be able to accomodate Devops releases.
* The json structure contains one key/value pair labled `devops_release`

**Example**
```
{
	"devops_release": "*.*.*"
}
```
