# How to set up a New Repository

1.  Clone this repo.
    ```
    git clone https://github.com/AuraDevelopmentTeam/GradleCommon.git
    ```
2.  Create a new repository, clone it and copy the path.
3.  Open the command prompt in the GradleCommon repository.
4.  Run this command:
    ```
    ./gradlew createNewProject "-PnewProjectDir=<newProjectDir>"
    ```
5.  Finally push with these two commands:
    ```
    git push -u origin --all
    git push -u origin --tags
    ```
6.  Done!

# How to update GradleCommon

1.  Run this command:
    ```
    ./gradlew updateGradleCommon
    ```
