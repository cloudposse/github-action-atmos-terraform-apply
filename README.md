
<!-- markdownlint-disable -->
# github-action-atmos-terraform-apply

 [![Latest Release](https://img.shields.io/github/release/cloudposse/github-action-atmos-terraform-apply.svg)](https://github.com/cloudposse/github-action-atmos-terraform-apply/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)
<!-- markdownlint-restore -->

[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

This Github Action is used to run Terraform apply for a single, Atmos-supported component with a saved planfile in S3 and DynamoDB.

---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps.
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]




It's 100% Open Source and licensed under the [APACHE2](LICENSE).












## Introduction

This Github Action is used to run Terraform apply for a single, Atmos-supported component with a saved planfile in S3 and DynamoDB.

Before running this action, first create and store a planfile with the companion action, [github-action-atmos-terraform-plan](https://github.com/cloudposse/github-action-atmos-terraform-plan).





## Usage



### Prerequisites

This GitHub Action requires AWS access for two different purposes. This action will attempt to first pull a Terraform planfile from a S3 Bucket with metadata in a DynamoDB table with one role. 
Then the action will run `terraform apply` against that component with another role. We recommend configuring 
[OpenID Connect with AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) 
to allow GitHub to assume roles in AWS and then deploying both a Terraform Apply role and a Terraform State role. 
For Cloud Posse documentation on setting up GitHub OIDC, see our [`github-oidc-provider` component](https://docs.cloudposse.com/components/library/aws/github-oidc-provider/).

In order to retrieve Terraform State, we configure an S3 Bucket to store plan files and a DynamoDB table to track plan metadata. Both will need to be deployed before running
this action. For more on setting up those components, see the `gitops` component (__documentation pending__). This action will then use the [github-action-terraform-plan-storage](https://github.com/cloudposse/github-action-terraform-plan-storage) action to update these resources.

### Workflow example

```yaml
  name: "atmos-terraform-apply"

  on:
    workflow_dispatch:
    pull_request:
      types:
        - closed
      branches:
        - main

  # These permissions are required for GitHub to assume roles in AWS
  permissions:
    id-token: write
    contents: read

  jobs:
    plan:
      runs-on: ubuntu-latest
      steps:
        - name: Plan Atmos Component
          uses: cloudposse/github-action-atmos-terraform-apply@v1
          with:
            component: "foobar"
            stack: "plat-ue2-sandbox"
            component-path: "components/terraform/s3-bucket"
            terraform-apply-role: "arn:aws:iam::111111111111:role/acme-core-gbl-identity-gitops"
            terraform-state-bucket: "acme-core-ue2-auto-gitops"
            terraform-state-role: "arn:aws:iam::999999999999:role/acme-core-ue2-auto-gitops-gha"
            terraform-state-table: "acme-core-ue2-auto-gitops"
            aws-region: "us-east-2"

```






<!-- markdownlint-disable -->

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| atmos-config-path | The path to the atmos.yaml file | atmos.yaml | false |
| atmos-version | Atmos version to use for vendoring. Default 'latest' | latest | false |
| aws-region | AWS region for assuming identity. | us-east-1 | false |
| commit-sha | Commit SHA to apply. Default: github.sha | ${{ github.sha }} | true |
| component | The name of the component to apply. | N/A | true |
| component-path | The path to the base component. Atmos defines this value as component\_path. | N/A | true |
| debug | Enable action debug mode. Default: 'false' | false | false |
| enable-infracost | Whether to enable infracost summary. Requires secret `infracost-api-key` to be specified. Default: 'false | false | false |
| infracost-api-key | Infracost API key | N/A | false |
| stack | The stack name for the given component. | N/A | true |
| terraform-apply-role | The AWS role to be used to apply Terraform. | N/A | true |
| terraform-state-bucket | The S3 Bucket where the planfiles are stored. | N/A | true |
| terraform-state-role | The AWS role to be used to retrieve the planfile from AWS. | N/A | true |
| terraform-state-table | The DynamoDB table where planfile metadata is stored. | N/A | true |
| terraform-version | The version of Terraform CLI to install. Instead of full version string you can also specify constraint string starting with "<" (for example `<1.13.0`) to install the latest version satisfying the constraint. A value of `latest` will install the latest version of Terraform CLI. Defaults to `latest`. | latest | false |
| token | Used to pull node distributions for Atmos from Cloud Posse's GitHub repository. Since there's a default, this is typically not supplied by the user. When running this action on github.com, the default value is sufficient. When running on GHES, you can pass a personal access token for github.com if you are experiencing rate limiting. | ${{ github.server\_url == 'https://github.com' && github.token \|\| '' }} | false |


## Outputs

| Name | Description |
|------|-------------|
| status | Apply Status. Either 'succeeded' or 'failed' |
<!-- markdownlint-restore -->



## Share the Love

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/github-action-atmos-terraform-apply)! (it helps us **a lot**)

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)



## Related Projects

Check out these related projects.



## References

For additional context, refer to some of these links.

- [github-action-atmos-terraform-plan](https://github.com/cloudposse/github-action-atmos-terraform-plan) - Companion GitHub Action to create and store Terraform plans for a given component
- [github-action-terraform-plan-storage](https://github.com/cloudposse/github-action-terraform-plan-storage) - GitHub Action to store Terraform plans


## Help

**Got a question?** We got answers.

File a GitHub [issue](https://github.com/cloudposse/github-action-atmos-terraform-apply/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/github-action-atmos-terraform-apply/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2023 [Cloud Posse, LLC](https://cpco.io/copyright)



## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

<!-- markdownlint-disable -->
|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Daniel Miller][milldr_avatar]][milldr_homepage]<br/>[Daniel Miller][milldr_homepage] |
|---|---|
<!-- markdownlint-restore -->

  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png
  [milldr_homepage]: https://github.com/milldr
  [milldr_avatar]: https://img.cloudposse.com/150x150/https://github.com/milldr.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]
<!-- markdownlint-disable -->
  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=newsletter
  [discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=discourse
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-apply&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=github-action-atmos-terraform-apply&url=https://github.com/cloudposse/github-action-atmos-terraform-apply
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=github-action-atmos-terraform-apply&url=https://github.com/cloudposse/github-action-atmos-terraform-apply
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/github-action-atmos-terraform-apply
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/github-action-atmos-terraform-apply
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/github-action-atmos-terraform-apply
  [share_email]: mailto:?subject=github-action-atmos-terraform-apply&body=https://github.com/cloudposse/github-action-atmos-terraform-apply
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/github-action-atmos-terraform-apply?pixel&cs=github&cm=readme&an=github-action-atmos-terraform-apply
<!-- markdownlint-restore -->
