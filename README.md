# System Documentation
System documentation repository for C2C Platform. It includes all documentation for C2C System, technical, environments and documentations for the platform. All files are markdown files (ext: .md) and can be treated as a text file with a already defined strcuture.
It uses [mkdocs](https://www.mkdocs.org/) for documenting contents and uses the [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) theme.

## Getting Started 
This will guide you on "How to create / update the system wiki documents" with C2C Platform related information. 
If you are only going to edit and modfiy documents and do not intend to publish skip to **How to create / update C2C Platform documents** section

## Setting up local environment
If you are using Windows machine launch command prompt, browse to the location where repository is cloned and Run "Setup.bat" file. This file will perform all required pre-requisite checks and setup your machine for documentation site. Once batch file is completed please validate if there are any errors.

Post successfull completion you are ready to perform documentation updates from your machine. Follow below steps for document updates.

### How to create / update markdown documents
You can use any editor to create / update documentation. Rule is to abide to a structure / format of markdown.
Basics of Markdown - <https://www.markdownguide.org/basic-syntax/>

1. Goto c2csystemwiki clone folder.
2. Open any .md placed under 'C2CPlatform/docs' file and start editing.
3. To create a new file, 
    a. Create a new .md file, give a proper name.
    b. place the file in appropriate folder.
    c. Open mkdocs.yml file, add the entry under "nav" section properly. 
       NOTE :: Do not distrub the mkdocs.yml document's alignment.
4. Once changes are complete, commit your changes to the c2csystemwiki repo.
   NOTE :: Take utmost care while doing the commits, all commits will be done to MAIN branch.       
       
### Veify changes locally
1. Goto c2csystemwiki clone folder
2. Go inside C2CPlatform folder
3. Launch command prompt from this path
   ```
   runlocal.bat
   ```
4. Copy http://127.0.0.8000 to browser and run.

### Verify changes in a local site
1. Goto c2csystemwiki clone folder
2. Go inside C2CPlatform folder
3. Launch command prompt from this path.
   ```
   build.bat
   ```
4.  Once build is complete it will launch you default browser with Index.html file.


### Publish your changes
1. Goto c2csystemwiki clone folder
2. Go inside C2CPlatform folder
3. Launch command prompt from this path.
   ```
   gitbuild.bat
   ```
4.  Once publish is complete, browse the website.

## Plugins and Extras
In addition to themes it uses below plugins
  * python-markdown - <https://python-markdown.github.io/install/>
  * git-revision-date-localized - <https://github.com/timvink/mkdocs-git-revision-date-localized-plugin>
  * mike - <https://github.com/jimporter/mike#usage>
  * Markdown Extradata - https://github.com/rosscdh/mkdocs-markdownextradata-plugin
  * Site print plugin - https://github.com/timvink/mkdocs-print-site-plugin 
  * Table creator from CSV file - https://github.com/timvink/mkdocs-table-reader-plugin 

## Extensions 
  * pymdownx.tabbed
  * pymdownx.superfences
  * pymdownx.details
  * admonition
  * attr_list
  * pymdownx.emoji

## CI/CD - Jenkins Pipeline to publish documentation

Jenkins job Pipeline url to trigger the build and publish it to the wiki site. https://jenkins-1.car2cloudapps.com/job/DEPLOYMENT/job/c2c-doc-wiki-publish/

### Build process 

#### What happens when build is triggered using pipeline?
For the given sprint version, it creates a new folder/updates the existing folder in the gh-pages branch, the Latest folder in the gh-pages branch and the version.json file in the gh-pages branch present in the github. Also publishes the changes to github repository. 

#### How the jenkinsfile works?
In the Jenkins job we have configured it to take the Jenkinfile from the pipeline folder path C2CPlatform/pipeline/c2c_documentation_jenkinsfile
1. The Jenkinsfile clones the repository "*c2c_systemwiki*" of the "*main*" branch as well as the "*gh-pages*" branch.
2. Then job triggers the build from the */pipeline/c2c_documentation_build.sh*
3. Once the build is successfull, the artifacts are created.
4. After this, triggers the */pipeline/c2c_documentation_publish.sh* which includes the logic for the publishing of the artifacts to documentation website.
5. And then commits the changes to github with the message commit as "build time and the user who has triggered by the jenkins job".  

### How to trigger the build manually?

#### Steps:
1. Login into the above jenkins URL (if you don't have access to the jenkins, please send an email to QCC2CDevOPS@cognizant.com for the jenkins access)   
2. Click on the Deployment tab, and then click on the job "**c2c-doc-wiki-publish**"    
3. On the left panel, click "Build with Parameters" provide the sprint_no and the version_number to be build and published. *Example*: if you are building the sprint 13 then provide the "*sprint_no*" as *13* and "*version_number*" as *0.13*    
4. Then click on the build.   

### Automatic trigger
We have automated the trigger of the jenkins pipeline daily at 10.00 PM IST. With the default settings (refer shell script in *pipeline* folder to find values) in the jenkinsfile.
If you want to change the default parameter value, then you have to modify in the jenkinsfile *C2CPlatform/pipeline/c2c_documentation_jenkinsfile* and commit the file to branch.

