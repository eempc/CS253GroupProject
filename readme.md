# CS253 Group Project

## Git quick guide

After you've installed Git onto your computer, start up a bash terminal in the folder where you will work on.

1. Click the "master" dropdown tab at the top left of the repository of this page
2. Type in a name for the branch, e.g. "my-feature-branch"
3. Click the create branch button
4. On git bash, type the following:
    1. `git clone https://github.com/eempc/TaxiProject`
    2. `git fetch; git pull`
    3. `git checkout -b <your branch name> origin/<your branch name>`
5. Start making coding changes
6. Commit your changes by:
    1. `git add <file>`
    2. `git commit -m "<commit message>"`
7. When done, type `git push origin` to push changes to the repository
8. Create a Pull Request to master and wait for approval

NB no release branch for something simple like this project