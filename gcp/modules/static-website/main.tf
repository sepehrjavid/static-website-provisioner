data "google_client_config" "client_config" {}

resource "random_string" "bucket_suffix" {
  for_each = var.branches
  length   = 4
  lower    = true
  upper    = false
  numeric  = false
  special  = false
}

resource "google_storage_bucket" "website_bucket" {
  for_each                    = var.branches
  name                        = "${each.value}-website-bucket-${random_string.bucket_suffix[each.key].result}"
  location                    = data.google_client_config.client_config.region
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

resource "google_storage_bucket_iam_member" "website_bucket_public_access" {
  for_each = google_storage_bucket.website_bucket
  bucket   = google_storage_bucket.website_bucket[each.key].name
  role     = "roles/storage.objectViewer"
  member   = "allUsers"
}

module "ci-cd" {
  count                      = var.enable_cicd ? 1 : 0
  source                     = "../ci-cd"
  website_buckets            = google_storage_bucket.website_bucket
  branches                   = var.branches
  github_access_token        = var.github_config.access_token
  github_app_installation_id = var.github_config.app_installation_id
  github_repo_uri            = var.github_config.repo_uri
}

