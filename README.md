# Branch to Branch : Override the Destination Branch

This action will override a destination branch from a source branch. The purpose is to run an automated test(s) of `source_branch` and push to `dest_branch` if automated test(s) are successful.

## Inputs

### `dest_branch`

**Required** The branch name of the branch to push `source_branch` push to. 

If the branch does not already exist, it will be created for you. 

### `source_branch`
**Required** The branch name of the branch to duplicate.

If the branch does not exist, action will fail.

### `commit_message`

Custom commit message. **default** "Automated commit from action""

### `GITHUB_TOKEN`
You must create a Personal Access Token otherwise this action will not run.



## Example usage
```
- name: Push from dev to prod branch.
  uses: Automattic/action-commit-to-branch@master
  with:
    dest_branch: 'dev'
    source_branch: 'prod'
    commit_message: 'Automated tests for main.'
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # Required
```


## Full Github Action example
This uses Django's built in tests:

```
name: Python-Django application

on: 
  push:
      branches:
         - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Set up Python 3.6
      uses: actions/setup-python@v1
      with:
        python-version: 3.6
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    - name: Run migrations
      run: python manage.py migrate
    - name: Run tests
      run: python manage.py test
    - name: Push main branch into production
      uses: codingforentrepreneurs/action-branch-to-branch@main
      with:
        dest_branch: 'production-v1'
        source_branch: 'main'
        commit_message: 'Release production version'
      env:
        GITHUB_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```

> Inspired and modified from [Automattic's commit-to-branch](https://github.com/Automattic/action-commit-to-branch).