# Welcome to INTRACS docs contributing guide

Thank you for showing interest in contributing to this project! You're awesome!

In this guide you will get an overview of the contribution workflow from opening an issue, creating a PR, reviewing, and merging the PR.

## New contributor guide

The INTRACS project is made of two parts, the first is the application made with Dart and Flutter, 
and the second one is the inertial device made with Arduino boards. The mobile application is meant to 
receive the raw inertial data from the inertial device and process it through computing methods (algorithms).

There are a lot of ways one can contribute to this project, like reporting and solving issues, submitting new features,
making UI and code improvements, and contributing with custom computing methods.

To get an overview of the project, read the [README](../README.md). Here are some resources to help you get started with open source contributions:

- [Finding ways to contribute to open-source on GitHub](https://docs.github.com/en/get-started/exploring-projects-on-github/finding-ways-to-contribute-to-open-source-on-github)
- [Set up Git](https://docs.github.com/en/get-started/quickstart/set-up-git)
- [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow)
- [Collaborating with pull requests](https://docs.github.com/en/github/collaborating-with-pull-requests)


## Getting started

First of all, you must read our [Code of Conduct](CODE_OF_CONDUCT.md), after that you can decide how you want to
contribute to the project, if you want to contribute with the mobile application or the inertial device you should 
take your time to read and understand comprehensively the [Project Architecture](PROJECT_ARCHITECTURE.md), however,
if you want just to contribute with custom computing methods, you just need a basic understanding of Dart and to
keep reading this guide. To get started with your environment, read the [installation guide](GET_STARTED.md). 

if you feel ready after those readings, then first and foremost choose or open an issue to work on.

### 1. Issues

#### Create a new issue

Take a couple of minutes to [search if an issue already exists](https://docs.github.com/en/github/searching-for-information-on-github/searching-on-github/searching-issues-and-pull-requests#search-by-the-title-body-or-comments). If a related issue doesn't exist, you can open a new issue using a relevant [issue form](https://github.com/brunotacca/INTRACS/issues/new/choose). There will be some options for you to choose then you can follow the guidelines provided on the template, make sure to read it all, and don't be afraid to send it. If you want to submit new computing methods, open an issue as a feature request.

#### Solve an issue

Scan through our [existing issues](https://github.com/brunotacca/INTRACS/issues) to find one that interests you. As a general rule, we don???t assign issues to anyone. If you find an issue to work on, you are welcome to open a PR with a fix.

### 2. Make Changes

#### Making changes in the mobile application

To make changes in the mobile application you must find or create a new issue related to a bug or new feature. The mobile application is built mostly over Dart language and it's primordial to understand this project structure, you can read the [Project Architecture](PROJECT_ARCHITECTURE.md) document to get this going.

If you want to change just the UI, you don't need a deep understanding of the architecture, but you will be limited to its actual inputs and outputs. If you want to improve the project architecture itself, you're welcome to suggest it as a feature request and make sure to make it the best way you can.

#### Making changes in the inertial device software

The inertial device software is meant to just send inertial data through Bluetooth with a simple 20 bytes (BLE 4.1) format. It's nothing more than that. It has a lot of room for code improvements, documentation, and readability. 

You can also make your own inertial device and integrate it with the application, if you want to add it to this public repository, we would love to add it along with our already built device, the more options the better. Make sure to write a detailed step-by-step acquisition and setting up guide to it.

#### Adding or Making changes in computing methods

You can choose to just contribute with a computing method to be listed in the application and try it out with the raw inertial data. You won't need a deep understanding of the project architecture and just need to follow the [Computing Methods](COMPUTING_METHODS.md) guide to doing it.

### 3. Commit your update

Commit the changes once you are happy with them. Be short and precise with your commit messages, read this [Free Code Camp](https://www.freecodecamp.org/news/writing-good-commit-messages-a-practical-guide/) article for some guidance in that matter.

Once your changes are ready, don't forget to self-review and test your own changes to speed up the review process.

### 4. Pull Request

When you're finished with the changes, create a pull request, also known as a PR.
- Fill in the template so that we can review your PR. This template helps reviewers understand your changes as well as the purpose of your pull request. 
- Don't forget to [link PR to issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue) if you are solving one.
- Enable the checkbox to [allow maintainer edits](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/allowing-changes-to-a-pull-request-branch-created-from-a-fork) so the branch can be updated for a merge. 
Once you submit your PR, a team member will review your proposal. We may ask questions or request additional information.
- We may ask for changes to be made before a PR can be merged, either using [suggested changes](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/incorporating-feedback-in-your-pull-request) or pull request comments. You can apply suggested changes directly through the UI. You can make any other changes in your fork, then commit them to your branch.
- As you update your PR and apply changes, mark each conversation as [resolved](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/commenting-on-a-pull-request#resolving-conversations).
- If you run into any merge issues, check out this [git tutorial](https://lab.github.com/githubtraining/managing-merge-conflicts) to help you resolve merge conflicts and other issues.

### 5. Your PR is merged!

Congratulations :tada::tada: 

The INTRACS project team thanks you :sparkles:. Welcome aboard.

