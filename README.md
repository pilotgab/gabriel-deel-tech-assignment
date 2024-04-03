# deel DevOps Tech Assignment

## APPLICATION OVERVIEW

This Deel DevOps Tech Assignment application exemplifies fundamental DevOps principles and practices with a streamlined design. Developed using Python and the Flask framework, this HTML/JavaScript web application uses a SQLite database for robust backend functionality. For consistency across various computing environments, I opted for Docker to containerize the application. I personally detailed the step-by-step build instructions within the Dockerfile, ensuring a smooth and uniform deployment experience.

In the developmental stages, I seamlessly incorporated Sentry into the application framework to facilitate real-time error tracking and efficient issue resolution. This strategic integration played a pivotal role in upholding code quality, enabling swift identification, and resolution of any encountered issues.

To optimize content delivery, I strategically employed AWS CloudFront as the Content Delivery Network (CDN) for the application. This implementation is specifically geared towards swiftly and efficiently delivering static content to users across the globe.

The GitHub Actions-managed Continuous Integration (CI) pipeline is crafted to facilitate a seamless and uniform update and deployment procedure. It kicks into action when there's a push event to the main branch, progressing through the following stages:

1. **Linting**: Initially, the codebase undergoes linting using `flake8` to detect style errors or potential bugs.

2. **Testing**: Following successful linting, the pipeline proceeds to install the application's dependencies and execute tests using `pytest`. The test results are then compiled into an HTML report and uploaded to an AWS S3 bucket.

3. **Configure AWS credentials**: I use security hardening stratagy with OpenID connect (OIDC) which allows the GitHub Actions workflows to access aws resources in the cloud, without having to store any credentials as long-lived GitHub secrets. This ensure the security of the pipeline and aws cloud platform.

4. **Building and Pushing Docker Image**: With passing tests, the pipeline advances to building a Docker image for the application and pushing it to Amazon ECR. The Docker image is labeled with the short SHA of the latest git commit.

5. **Syncing Directories to S3 and Invalidating CloudFront Cache**: The `static` directories is synchronized with an S3 bucket, and the `index.html` file from the `templates` directory is uploaded to the same S3 bucket. The CloudFront cache for `index.html` is invalidated to ensure the latest file version is served.

6. **Updating Helm Chart Values and Triggering Argocd Deployment**: The final step entails updating the `values.yaml` file of the Helm chart with the new image repository and tag. These modifications are then committed and pushed to the `main` branch of the GitHub repository, triggering Argo CD to update the application deployment on the EKS cluster.

Over the course of three days, a web application was developed that incorporates various DevOps practices, including containerization, orchestration, continuous delivery, infrastructure as code, and real-time monitoring. This project highlight the efficacy of a well-implemented CI pipeline, ensuring the application is consistently deployable and subjected to rigorous testing before each deployment.

## TECHNOLOGY STACK

The deel test application is built upon a diverse set of technologies, each chosen for its specific strengths and contributions:

Python/Flask: I Employed this to construct the web application, Python with Flask offers simplicity and flexibility, aligning perfectly with the project's requirements.

SQLite: Chosen as the backend database, SQLite's lightweight design and user-friendly features make it an optimal choice.

Docker: I containerised the application using Docker, providing a streamlined and consistent deployment process.

Amazon Web Services (AWS): Various AWS services were harnessed for deploying and managing the application, encompassing IAM,S3,ECR, EKS, VPC,karpenter provisioner and CloudFront.

AWS Elastic Container Registry (ECR): I store the Docker image Amazion Elastic Container Registry (ECR), benefiting from AWS's fully-managed container registry.

Kubernetes (AWS EKS): I use AWS EKS, a managed Kubernetes service, to orchestrates and oversees the application's containers.

Helm: I packaged the application into Helm charts, leveraging Helm's prowess in managing Kubernetes resources and optimizing deployment.

ArgoCD: I employed argocd for continuous delivery, ArgoCD ensures the application's live state aligns with the specified state in the Git repository.

GitHub Actions: I build CI pipeline using GitHub Actions,to automate the building and testing processes whenever changes are pushed to the main branch of the repository.

Terraform: I use terraform to provision infrastructure declaratively through code, allowing for version control, consistency and reproducability of the infrastructure deployment.

Scalr (Terraform State Management): I integrate Scalr with version control system (Git) to manage Terraform code versions, Terraform state files, offering a secure and centralized location for storing and locking state. This helps in avoiding state file conflicts, provides better visibility into changes centrally, making it easier to collaborate and maintain consistency across different projects and teams.

AWS VPC (Virtual Private Cloud): I deployed the application to operates within a secure AWS VPC, providing an isolated cloud network for heightened security.

AWS CloudFront (CDN): I created AWS CloudFront, a robust content delivery network, which expeditiously delivers the application's static files worldwide.

Grafana Prometheus, and loki stack: I integrated grafana loki stack on the cluster monitoring purposes. this visualizes the application's metrics, offering insights into system performance,application behaviour,and infastructure health.

Sentry: I use Sentry for code scanning and testing, Sentry ensures code quality and identifies potential issues early in the development process.

These technologies collaboratively contributed to the successful development, deployment, and management of the deel test application, forming a resilient, scalable, and efficient application infrastructure.

## INSTALLATIONS PROCEDURE

1. **Clone the Repository:**

   - I begin by creating and cloning the repository to my local environment.

2. **Build, Test, and Package Docker Image:**

   - I utilized the GitHub CI workflow to automatically build, test, and package the Docker image and ensure is pushed to AWS ECR.

3. **Setup VPC, EKS Cluster, and CDN with Terraform:**

   - I executed the Terraform scripts provided to establish the Virtual Private Cloud (VPC), Amazon EKS cluster, and Content Delivery Network (CDN).

4. **Deploy the Application with Argo CD and Helm:**
   - I deployed the application using Argo CD in conjunction with Helm. This dynamic duo streamlines the deployment process and ensures that the application is in sync with the desired state specified in the Git repository.

By following these steps, I successfully set up the development environment, built and pushed the Docker image to AWS ECR, established the necessary infrastructure with Terraform, and deployed the application using Argo CD and Helm. This comprehensive installation process guarantees a smooth and efficient deployment of the application.

## Link to the application achitectural design: https://i.ibb.co/5WWgmrt/deel-test-application.png

## Link to the infrastucture achitectural design: https://i.ibb.co/jDpX2dP/deel-test-infrastructure.png

## Link to the argocd server: http://a994150105ae04c639b8a1794dfc22d2-969647022.eu-west-1.elb.amazonaws.com

## Link to the deel-test-application: http://a7b6f790253db45bbb03851186ea64a8-07ca72de5ecf16f3.elb.eu-west-1.amazonaws.com

## In the event that the deel test application transitions into a 3-tier microservices app, my approach would involve breaking it down into three integral parts:

1. **Interface Layer::**
   I would transform the front-end, composed of HTML/JavaScript, into its own microservice. This microservice would be responsible for handling user interactions and updating the user interface by fetching data from the backend. To improve delivery speed and reliability, I'd use AWS CloudFront to serve static files such as CSS, images, or JavaScript libraries.

2. **Operational Logic Stratum:**
   In this layer, I would divide the existing Flask backend into smaller, focused microservices. Each of these microservices would handle a specific task, providing increased agility and scalability.

3. **Data Storage Stratum:**
   Instead of relying on a single SQLite database, I would assign a dedicated database to each microservice. This approach allows for independent operation and management of data for each component.

Concerning the CI/CD pipeline, I would personally opt for a GitOps approach. I'd initiate changes with a git commit, triggering a GitHub Actions workflow. This workflow would build a new Docker image for the updated microservice and push it to AWS ECR. ArgoCD, keeping an eye on the GitHub repository, would then deploy the new microservice to the AWS EKS cluster.

## SCHEDULE FOR MY TASKS

Getting the deel test app from scratch to launch took me 3 days:

**Day 1**: I kicked things off by crafting the backend server using Python and Flask. My goal was to make sure it could fetch and print the origin public IP address of any request it receives, reverse it and showcase values accurately.

**Day 2**: I dived into writing Infrastructure as Code (IaC) scripts with Terraform. I used it as a blueprints for setting up AWS services like ECR, S3, EKS, VPC, and CloudFront.

**Day 3**: This day was all about refining the infrastructure setup. I went through every detail to ensure all AWS components were properly configured and communicating smoothly. I also double-checked that the app should be visible to the world once it's out there.

finally, I build a continuous integration and continuous delivery (CI/CD) pipeline. Using GitHub Actions, I automated the build and testing process every time I pushed changes to the repository main branch. ArgoCD played its part in making sure the app kept flowing to the AWS EKS cluster.

In a nutshell, it took me three days to bring the deel test app to life, step by step.
