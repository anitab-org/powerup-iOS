[![Travis](https://img.shields.io/travis/rust-lang/rust.svg?style=plastic)](https://github.com/systers/powerup-iOS)

# PowerUp - iOS [![Build Status](https://travis-ci.org/systers/powerup-iOS.svg?branch=GSoC17)](https://travis-ci.org/systers/powerup-iOS)

PowerUp is an educational mobile game app that seeks to empower young girls to take charge of their reproductive health
and self-esteem by navigating the life of their Avatar.

## Setup for Developers
1. Make sure you have Xcode IDE downloaded on your machine for software development for iOS.<br />
2. Fork the systers project. Go to [Powerup-iOS](https://github.com/systers/powerup-iOS) and click on Fork in the top right corner. Fork the repo on your Github id. Make sure that you don’t have any existing repo with the same name in your profile else there will be conflicts.<br />
3. Make sure you have installed [Github Desktop(for Mac)](https://desktop.github.com/).<br />
4. Open Github Desktop, click on Clone Repository in File Menu. Clone the forked repo to get a local copy on your system.<br />
5. Fetch the latest version of code from the appropriate branch (usually "develop").<br />
## Configure remotes
When a repository is cloned, it has a default remote called `origin` that points to your fork on GitHub, not the original repository it was forked from. To keep track of the original repository, you should add another remote named `upstream`:<br />
1. Get the path where you have your git repository on your machine. Go to that path in Terminal using cd. Alternatively, Right click on project in Github Desktop and hit ‘Open in Terminal’.<br />
2. Run `git remote -v`  to check the status you should see something like the following:<br />
> origin    https://github.com/YOUR_USERNAME/powerup-iOS.git (fetch)<br />
> origin    https://github.com/YOUR_USERNAME/powerup-iOS.git (push)<br />
3. Set the `upstream`:<br />
 `git remote add upstream https://github.com/systers/powerup-iOS.git`<br />
4. Run `git remote -v`  again to check the status, you should see something like the following:<br />
> origin    https://github.com/YOUR_USERNAME/powerup-iOS.git (fetch)<br />
> origin    https://github.com/YOUR_USERNAME/powerup-iOS.git (push)<br />
> upstream  https://github.com/systers/powerup-iOS.git (fetch)<br />
> upstream  https://github.com/systers/powerup-iOS.git (push)<br />
5. To update your local copy with remote changes, run the following:<br />
`git fetch upstream develop`<br />
 `git rebase  upstream/develop`<br />
This will give you an exact copy of the current remote, make sure you don't have any local changes.<br />
6. Project set-up is complete. For more details and additional git commands, [click here](https://docs.google.com/document/d/1N_-zmmjPn6D1H6wTdF4z66mFGT3af_FWbfGvLKkeY1w/edit#bookmark=id.lsmu7e8l1dnn).<br />
## Contributing and developing a feature
1. Make sure you are in the develop branch `git checkout develop`.<br />
2. Sync your copy `git pull --rebase upstream develop`.<br />
3. Create a new branch with a meaningful name `git checkout -b branch_name`.<br />
4. Develop your feature on Xcode IDE  and run it using the simulator or connecting your own iphone.<br />
5. Add the files you changed `git add file_name` (avoid using `git add .`).<br />
6. Commit your changes `git commit -m "Message briefly explaining the feature"`.<br />
7. Keep one commit per feature. If you forgot to add changes, you can edit the previous commit `git commit --amend`.<br />
8. Push to your repo `git push origin branch-name`.<br />
9. Go into [the Github repo](https://github.com/systers/powerup-iOS/) and create a pull request explaining your changes.<br />
10. If you are requested to make changes, edit your commit using `git commit --amend`, push again and the pull request will edit automatically.<br />
11. If you have more than one commit try squashing them into single commit by following command:<br />
 `git rebase -i origin/master~n master`(having n number of commits).<br />
 12. Once you've run a git rebase -i command, text editor will open with a file that lists all the commits in current branch, and in front of each commit is the word "pick". For every line except the first, replace the word "pick" with the word "squash".<br />
 13. Save and close the file, and a moment later a new file should pop up in  editor, combining all the commit messages of all the commits. Reword this commit message into meaningful one briefly explaining all the features, and then save and close that file as well. This commit message will be the commit message for the one, big commit that you are squashing all of your larger commits into. Once you've saved and closed that file, your commits of current branch have been squashed together.<br />
14. Force push to update your pull request with command `git push origin branchname --force`.<br/>
## Contributing Guidelines
[Click](https://github.com/systers/powerup-iOS/wiki/How-to-Contribute) here to find the contributing guidelines for the project and follow them before sending a contribution.<br />

## Documentation of PowerUp-iOS
Links to the Documentation:<br />

[2017](https://docs.google.com/document/d/1-45bBWAL8oh5o_1bc42BXGDKTHlGrQW0PCN9gFtlt6U/edit?usp=sharing)<br/>
[2016](https://docs.google.com/document/d/1N_-zmmjPn6D1H6wTdF4z66mFGT3af_FWbfGvLKkeY1w/edit?usp=sharing)<br/>
[2015](https://docs.google.com/document/d/1WkhcVrUs-B_vlCBknNPYqxqc7_7wVrBF2pV0bKu_EiQ/edit?usp=sharing)

