# Amplify deployment (frontend/) - QuizUp

This Terraform deploys the React UI (located in `frontend/`) to AWS Amplify. It mirrors the modular approach from DALScooter.

## Prerequisites

- A GitHub repository containing this project (with `frontend/` folder)
- A GitHub classic personal access token with scopes:
  - `repo` (or `public_repo` for public repos)
  - `admin:repo_hook`

## Configure

Create `infra/terraform.tfvars`:

```
project_name           = "quizup"
region                 = "us-east-1"
amplify_repository_url = "https://github.com/<your-user>/<your-repo>.git"
github_oauth_token     = "ghp_XXXXXXXXXXXXXXXXXXXXXXXX"
branch_name            = "main"
```

> Tip: Instead of placing the token in a file, you can export it just for this session:
>
> PowerShell:
> ```powershell
> $env:TF_VAR_github_oauth_token = "ghp_..."
> ```

## Deploy

```powershell
cd infra
terraform init -reconfigure
terraform apply
```

Outputs:

- `amplify_branch_url` – Your app URL

## Next steps

After the UI is live, you can add modules for Cognito, API Gateway + Lambdas, and storage, and then pass their outputs into the Amplify environment variables by wiring them into `modules/amplify_app`.


