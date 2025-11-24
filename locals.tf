locals {
  tags = merge(var.additional_tags, {
    "Business Service Number" = var.business_service_number
    "applicationname"         = var.application_name
    "env"                     = var.env
    "iac"                     = var.iac
    "managedby"               = var.managed_by
    "alerting"                = var.alerting
  })

  addtional_role_assignments = var.backend_storage_id == null ? [] : [
    { role = "Storage Blob Data Contributor", scope = var.backend_storage_id }
  ]

}
