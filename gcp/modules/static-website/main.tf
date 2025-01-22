data "google_project" "project" {
}

resource "google_storage_bucket" "website_bucket" {
  for_each                    = toset(var.branches)
  name                        = "${each.value}-website-bucket"
  location                    = var.region
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
  count  = var.enable_cicd ? 1 : 0
  source = "../ci-cd"
  # website_buckets            = google_storage_bucket.website_bucket
  project_number             = data.google_project.project.number
  logging_project_id         = data.google_project.project.project_id
  region                     = var.region
  branches                   = var.branches
  github_access_token        = var.github_access_token
  github_app_installation_id = var.github_app_installation_id
  github_repo_uri            = var.github_repo_uri
}

