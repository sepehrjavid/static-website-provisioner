resource "google_project_service" "project" {
  for_each = var.enable_cicd ? toset(["secretmanager.googleapis.com", "cloudbuild.googleapis.com"]) : []
  service  = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy         = true
  disable_dependent_services = true
}

resource "google_secret_manager_secret" "github_token_secret" {
  secret_id = "github_access_token"

  replication {
    auto {}
  }

  depends_on = [google_project_service.project]
}

resource "google_secret_manager_secret_version" "github_token_secret_version" {
  secret      = google_secret_manager_secret.github_token_secret.id
  secret_data = var.github_config.access_token
}

data "google_iam_policy" "serviceagent_secretAccessor" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.github_token_secret.project
  secret_id   = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.serviceagent_secretAccessor.policy_data
}

resource "google_cloudbuildv2_connection" "git_connection" {
  location = data.google_client_config.client_config.region
  name     = "repository"

  github_config {
    app_installation_id = var.github_config.app_installation_id
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
    }
  }
  depends_on = [google_secret_manager_secret_iam_policy.policy]
}

resource "google_cloudbuildv2_repository" "git_repository" {
  location          = data.google_client_config.client_config.region
  name              = "website-repo"
  parent_connection = google_cloudbuildv2_connection.git_connection.name
  remote_uri        = var.github_config.repo_uri
}

resource "google_service_account" "website_build_sa" {
  for_each     = var.branches
  account_id   = "${each.key}-website-build-sa"
  display_name = "website Cloud Build SA"
}

resource "google_project_iam_member" "website_log_writer" {
  for_each = google_service_account.website_build_sa
  project  = data.google_client_config.client_config.project
  role     = "roles/logging.logWriter"
  member   = "serviceAccount:${google_service_account.website_build_sa[each.key].email}"
}

resource "google_storage_bucket_iam_member" "build_sa_write_access" {
  for_each = var.branches
  bucket   = google_storage_bucket.website_bucket[each.key].name
  role     = "roles/storage.legacyBucketWriter"
  member   = "serviceAccount:${google_service_account.website_build_sa[each.key].email}"
}

resource "google_cloudbuild_trigger" "git_trigger" {
  for_each        = var.branches
  name            = each.value
  location        = data.google_client_config.client_config.region
  service_account = google_service_account.website_build_sa[each.key].id
  filename        = "cloudbuild.yaml"

  repository_event_config {
    repository = google_cloudbuildv2_repository.git_repository.id

    push {
      branch = each.value
    }
  }
}

