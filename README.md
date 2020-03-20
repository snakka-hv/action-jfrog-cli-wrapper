# action-jfrog-cli-wrapper
Jfrog cli wrapper that can be used within GH actions to publish artifacts

## Usage
```
- name: Upload to artifactory
         uses: snakka-hv/jfrog-cli-publisher@master
         with:
           url: 'http://<ARTIFACTORY_URL>/artifactory'
           credentials type: 'username'
           user: ${{ secrets.ARTIFACTORY_USER }}
           password: ${{ secrets.ARTIFACTORY_PASSWORD }}
           artifactFrom: >
             artifact1.jar;
             artifact2.war;
             somePath/subpath/artifact3.jar;
           artifactTo: 'project-deployments/path/'
           buildName: 'experimental-build'
           buildNumber: 1
           publish: true
```
* credentials: Type of authentication to use. Must be one of username, apikey or accesstoken. Defaults to apikey.
* apiKey: if credentials if of type apiKey
* access token: if credentials is of type acess token
* user and password: if credentials is of type username
* artifactFrom: Multiline string of artifacts that need to be uploaded
* artifactTo: Path on artifactory where the artifacts need to be uploaded
* publish: Specify whether the uploaded artifacts need to be published into build browser
* buildName: Name under which these artifacts need to be published. Needed only if publish is true
* buildNumber: Number for tracking the build info. Needed only if publish is true