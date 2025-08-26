# Google Cloud Run for web-service-epoch-axum

<https://console.cloud.google.com/run?project=joelparkerhenderson-demo>

✨ Google Cloud Run is a fully managed, serverless platform that lets you run containers on Google's infrastructure. It automatically scales your applications, handles all underlying infrastructure management, and allows you to focus on writing code. Cloud Run supports various languages and frameworks via source-based deployments or allows you to bring your own container image. It integrates with other Google Cloud services and can run long-running services or one-off jobs that execute to completion.

## Create

<https://console.cloud.google.com/run/create?project=joelparkerhenderson-demo>

- Create service: GitHub. Continuously deploy from a repository (source or function). We choose this because we happen to use GitHub for our code.

- Click button "Set up with cloud build". 

### Cloud Build

Promo says: "Build, test, and deploy on our serverless CI/CD platform. New customers get $300 in free credits to spend on Cloud Build. All customers get 2,500 build-minutes free per month, not charged against your credits."

- Repository provider: GitHub. Click the link "authenticate". Do the authentication process. Add Google to whichever GitHub repostory you want.

- Repository: web-service-epoch-axum

- Branch: ^main$

- Build type: Dockerfile

- Dockerfile directory: (blank). Location of the directory containing the Dockerfile in the repository. Defaults to the repository root.

- Source location: /Containerfile

- Dockerfile name: Containerfile. This is because we prefer using the vendor-neutral name, which is also compatible with Podman and any other OCI tool.

### Configure

- Service name: web-service-epoch-axum

- Region: europe-west1 (Belgium). This region is convenient for Europe, and gives Google Tier 1 pricing (which is cheaper than Google Tier 2), and can provide GPUs, and has low-CO2 emissions ratings.

- Endpoint URL: https://web-service-epoch-axum-682195254020.europe-west1.run.app

- Authentication: Allow public access. No authentication checks will be performed.

- Billing: Request-based. Charged only when processing requests. CPU is limited outside of requests.

- Service scaling

  - Auto-scaling

    - Minimum number of instances: 0. We choose 0 because we're OK with slow cold starts.

    - Minimum number of instances: 2. We choose 2 because we want to use auto-scaling but not much.

  - Ingress

    - All. Allow direct access to your service from the internet.


## Troubleshoot

Click the link "Build history".

If the most-recent build has an error, then click the link for that build.

### Troubleshoot "unable to evaluate symlinks in Dockerfile path""

If you get this kind of error message:

- "Unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /workspace/Dockerfile: no such file or directory"

Then try this:


## Trigger

- Source: joelparkerhenderson/web-service-epoch-axum 

- Name: web-service-epoch-axum-europe-west1-joelparkerhenderson

- Region: global

- Description: Build and deploy to Cloud Run service web-service-epoch-axum on push to "^main$" (This can be anything you want.)

- Event: Push to a branch

- Tags: 

  - gpc-cloud-build-deploy-cloud-run

  - gpc-cloud-build-deploy-cloud-run-managed

  - web-service-epoch-axum

- Source

  - Repository service: Cloud Build repositories

  - Repository generation: 1st Gen (??)

  - Repository: joelparkerhenderson/web-service-epoch-axum (GitHub App)

  - Branch: ^main$

- Click "Save".

### Run trigger

- To run the trigger, click "Run". 

- You should see a bottom toast "Build started on main branch". 

- Click the toast link "Show".

You should see build output with steps such as:

```stdout
Starting build "b6553260-12e9-47af-9677-364da4b0dfbe"
Step 1/15 : FROM alpine
Step 2/15 : RUN apk --update add openssl
Step 3/15 : COPY  target/x86_64-unknown-linux-musl/release/web-service-epoch-axum /opt/web-service-epoch-axum
Step 4/15 : WORKDIR /opt
Step 5/15 : CMD ["/opt/web-service-count-axum"]
Step 6/15 : EXPOSE 8080
Step 7/15 : HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3   CMD curl -f http://localhost:8080/ || exit 1
Step 8/15 : LABEL org.opencontainers.image …
Successfully built cabb50c59c2a
PUSH
DONE
```
