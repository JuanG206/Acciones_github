Automated Git Script with GitHub CLI

This Bash script simplifies common Git and GitHub tasks, such as creating/deleting branches, performing merges, initializing repositories, and managing remotes in GitHub from the terminal.

- Requirements

To use this script properly, you need:

    Linux / WSL / macOS with bash.

    Git installed and configured:
    git --version

    GitHub CLI (gh) installed:
    gh --version
    Installation: https://cli.github.com/

    Authentication in GitHub CLI:
    gh auth login
    It is recommended to use SSH or a personal access token.

    Write permissions in the working directory (⚠️ do not run with sudo, otherwise files may end up owned by root).

- Installation

   1) Clone or copy the script to your machine.

   2) Make it executable:
      chmod +x script_acciones_github.sh

   3) Run it:
    ./script_acciones_github.sh

- Menu Features

When executed, the script shows an interactive menu with the following options:

    Create a new branch → Creates and switches to a new branch.

    Delete a branch → Deletes a local branch (shows available ones before selection).

    Merge a branch into main → Merges a selected branch into main and pushes to remote.

    List branches and directory structure → Displays local and remote branches.

    Configure Git in this directory → Initializes Git, creates an initial commit, and allows you to:

        Create a new remote repo on GitHub.

        Update the URL of an existing remote.

        Delete a remote repo on GitHub.

    Exit → Terminates the script.

! Warnings !

    The script can delete GitHub repositories if you choose that option. Double-check before confirming.

    If executed with sudo, files will be owned by root, which may cause permission issues (you may also see a lock icon in your terminal prompt).

    Do not use it in system-critical directories (/, /etc, /var, etc.).

- Adapting for Other Users

If another user wants to run this script:

    Script location: it can be placed in any directory. To make it global:

        Copy to /usr/local/bin/ (requires admin rights).

        Or add the folder to $PATH.

    GitHub CLI configuration: each user must run:
    gh auth login
    with their own GitHub account.

    Default branch name:

        Currently, it forces the default branch to main.

        To use master or another name, modify this line inside the configurar_git function:
        git branch -M main

    Repo visibility on GitHub:

        By default, the repo is created as public:
        gh repo create "$repo_name" --public --source=. --push

        To make it private, change it to:
        gh repo create "$repo_name" --private --source=. --push

- Example Usage

./script_acciones_github.sh

Expected output:
==============================
AUTOMATED GIT MENU

    Create a new branch

    Delete a branch

    Merge a branch into main

    List branches and directory structure

    Configure Git in this directory

    Exit
    ==============================
    Select an option [1-6]:

- Best Practices

    Use SSH for GitHub authentication.

    Never run the script with sudo.

    Test it first in sample repos before using it on important projects.

    Keep this script under version control to track changes.

